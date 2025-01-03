import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:surface/providers/sn_attachment.dart';
import 'package:surface/providers/sn_network.dart';
import 'package:surface/providers/user_directory.dart';
import 'package:surface/providers/websocket.dart';
import 'package:surface/types/chat.dart';
import 'package:surface/types/websocket.dart';
import 'package:uuid/uuid.dart';

class ChatMessageController extends ChangeNotifier {
  static const kChatMessageBoxPrefix = 'nex_chat_messages_';
  static const kSingleBatchLoadLimit = 100;

  late final SnNetworkProvider _sn;
  late final UserDirectoryProvider _ud;
  late final WebSocketProvider _ws;
  late final SnAttachmentProvider _attach;

  StreamSubscription? _wsSubscription;

  ChatMessageController(BuildContext context) {
    _sn = context.read<SnNetworkProvider>();
    _ud = context.read<UserDirectoryProvider>();
    _ws = context.read<WebSocketProvider>();
    _attach = context.read<SnAttachmentProvider>();
  }

  bool isPending = true;
  bool isLoading = false;

  int? messageTotal;

  bool get isAllLoaded => messageTotal != null && messages.length >= messageTotal!;

  String? _boxKey;
  SnChannel? channel;
  SnChannelMember? profile;

  /// Messages are the all the messages that in the channel
  final List<SnChatMessage> messages = List.empty(growable: true);

  /// Unconfirmed messages are the messages that sent by client but did not receive the reply from websocket server.
  /// Stored as a list of nonce to provide the loading state
  final List<String> unconfirmedMessages = List.empty(growable: true);

  Box<SnChatMessage>? get _box => (_boxKey == null || isPending) ? null : Hive.box<SnChatMessage>(_boxKey!);

  final List<SnChannelMember> typingMembers = List.empty(growable: true);
  final Map<int, Timer> typingInactiveTimer = {};

  Future<void> initialize(SnChannel chan) async {
    channel = chan;

    // Initialize local data
    _boxKey = '$kChatMessageBoxPrefix${chan.id}';
    await Hive.openBox<SnChatMessage>(_boxKey!);

    // Fetch channel profile
    final resp = await _sn.client.get(
      '/cgi/im/channels/${chan.keyPath}/me',
    );
    profile = SnChannelMember.fromJson(
      resp.data as Map<String, dynamic>,
    );

    _wsSubscription = _ws.stream.stream.listen((event) {
      switch (event.method) {
        case 'events.new':
          final payload = SnChatMessage.fromJson(event.payload!);
          _addMessage(payload);
          break;
        case 'status.typing':
          if (event.payload?['channel_id'] != channel?.id) break;
          final member = SnChannelMember.fromJson(event.payload!['member']);
          if (member.id == profile?.id) break;
          if (!typingMembers.any((x) => x.id == member.id)) {
            typingMembers.add(member);
            print('Typing member: ${typingMembers.map((ele) => member.id)}');
            notifyListeners();
          }
          typingInactiveTimer[member.id]?.cancel();
          typingInactiveTimer[member.id] = Timer(const Duration(seconds: 3), () {
            typingMembers.removeWhere((x) => x.id == member.id);
            typingInactiveTimer.remove(member.id);
            notifyListeners();
          });
      }
    });

    isPending = false;
    notifyListeners();
  }

  Timer? _typingNotifyTimer;
  bool _typingStatus = false;

  Future<void> _sendTypingStatusPackage() async {
    _ws.conn?.sink.add(jsonEncode(
      WebSocketPackage(
        method: 'status.typing',
        endpoint: 'im',
        payload: {
          'channel_id': channel!.id,
        },
      ).toJson(),
    ));
  }

  void pingTypingStatus() {
    if (!_typingStatus) {
      _sendTypingStatusPackage();
      _typingStatus = true;
    }

    if (_typingNotifyTimer == null || !_typingNotifyTimer!.isActive) {
      _typingNotifyTimer?.cancel();
      _typingNotifyTimer = Timer(const Duration(milliseconds: 1850), () {
        _typingStatus = false;
      });
    }
  }

  Future<void> _saveMessageToLocal(Iterable<SnChatMessage> messages) async {
    if (_box == null) return;
    await _box!.putAll({
      for (final message in messages) message.id: message,
    });
  }

  Future<void> _addUnconfirmedMessage(SnChatMessage message) async {
    SnChatMessage? quoteEvent;
    if (message.quoteEventId != null) {
      quoteEvent = await getMessage(message.quoteEventId as int);
    }

    final attachmentRid = List<String>.from(
      message.body['attachments']?.cast<String>() ?? [],
    );
    final attachments = await _attach.getMultiple(attachmentRid);
    message = message.copyWith(
      preload: SnChatMessagePreload(
        quoteEvent: quoteEvent,
        attachments: attachments,
      ),
    );

    messages.insert(0, message);
    unconfirmedMessages.add(message.uuid);
    notifyListeners();
  }

  Future<void> _addMessage(SnChatMessage message) async {
    SnChatMessage? quoteEvent;
    if (message.quoteEventId != null) {
      quoteEvent = await getMessage(message.quoteEventId as int);
    }

    final attachmentRid = List<String>.from(
      message.body['attachments']?.cast<String>() ?? [],
    );
    final attachments = await _attach.getMultiple(attachmentRid);
    message = message.copyWith(
      preload: SnChatMessagePreload(
        quoteEvent: quoteEvent,
        attachments: attachments,
      ),
    );

    final idx = messages.indexWhere((e) => e.uuid == message.uuid);
    if (idx != -1) {
      unconfirmedMessages.remove(message.uuid);
      messages[idx] = message;
    } else {
      messages.insert(0, message);
    }
    await _applyMessage(message);
    notifyListeners();

    if (_box == null) return;
    await _box!.put(message.id, message);
  }

  Future<void> _applyMessage(SnChatMessage message) async {
    if (message.channelId != channel?.id) return;

    switch (message.type) {
      case 'messages.edit':
        if (message.relatedEventId != null) {
          final idx = messages.indexWhere((x) => x.id == message.relatedEventId);
          if (idx != -1) {
            final newBody = message.body;
            newBody.remove('related_event');
            messages[idx] = messages[idx].copyWith(
              body: newBody,
              updatedAt: message.updatedAt,
            );
            if (_box!.containsKey(message.relatedEventId)) {
              await _box!.put(message.relatedEventId, messages[idx]);
            }
          }
        }
      case 'messages.delete':
        if (message.relatedEventId != null) {
          messages.removeWhere((x) => x.id == message.relatedEventId);
          if (_box!.containsKey(message.relatedEventId)) {
            await _box!.delete(message.relatedEventId);
          }
        }
    }
  }

  Future<void> sendMessage(
    String type,
    String content, {
    int? quoteId,
    int? relatedId,
    List<String>? attachments,
    SnChatMessage? editingMessage,
  }) async {
    if (channel == null) return;
    const uuid = Uuid();
    final nonce = uuid.v4();
    final body = {
      'text': content,
      'algorithm': 'plain',
      if (quoteId != null) 'quote_event': quoteId,
      if (relatedId != null) 'related_event': relatedId,
      if (attachments != null && attachments.isNotEmpty) 'attachments': attachments,
    };

    // Mock the message locally
    final createdAt = DateTime.now();
    final message = SnChatMessage(
      id: 0,
      createdAt: createdAt,
      updatedAt: createdAt,
      deletedAt: null,
      uuid: nonce,
      body: body,
      type: type,
      channel: channel!,
      channelId: channel!.id,
      sender: profile!,
      senderId: profile!.id,
      quoteEventId: quoteId,
      relatedEventId: relatedId,
    );
    _addUnconfirmedMessage(message);

    // Send to server
    try {
      await _sn.client.request(
        editingMessage != null
            ? '/cgi/im/channels/${channel!.keyPath}/messages/${editingMessage.id}'
            : '/cgi/im/channels/${channel!.keyPath}/messages',
        data: {
          'type': type,
          'uuid': nonce,
          'body': body,
        },
        options: Options(
          method: editingMessage != null ? 'PUT' : 'POST',
        ),
      );
    } catch (err) {
      // ignore
    }
  }

  Future<void> deleteMessage(SnChatMessage message) async {
    if (message.channelId != channel?.id) return;

    try {
      await _sn.client.delete(
        '/cgi/im/channels/${channel!.keyPath}/messages/${message.id}',
      );
    } catch (err) {
      // ignore
    }
  }

  /// Check the local storage is up to date with the server.
  /// If the local storage is not up to date, it will be updated.
  Future<void> checkUpdate() async {
    if (_box == null) return;
    if (_box!.isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      final resp = await _sn.client.get(
        '/cgi/im/channels/${channel!.keyPath}/events/update',
        queryParameters: {
          'pivot': _box!.values.last.id,
        },
      );
      if (resp.data['up_to_date'] == true) return;
      // Only preload the first 100 messages to prevent first time check update cause load to server and waste local storage.
      // FIXME If the local is missing more than 100 messages, it won't be fetched, this is a problem, we need to fix it.
      final countToFetch = math.min(resp.data['count'] as int, 100);

      for (int idx = 0; idx < countToFetch; idx += kSingleBatchLoadLimit) {
        await getMessages(kSingleBatchLoadLimit, idx, forceRemote: true);
      }
    } catch (err) {
      rethrow;
    } finally {
      await loadMessages();
      isLoading = false;
      notifyListeners();
    }
  }

  /// Get a single event from the current channel
  /// If it was not found in local storage we will look it up in remote
  Future<SnChatMessage?> getMessage(int id) async {
    SnChatMessage? out;
    if (_box != null && _box!.containsKey(id)) {
      out = _box!.get(id);
    }

    if (out == null) {
      try {
        final resp = await _sn.client.get('/cgi/im/channels/${channel!.keyPath}/events/$id');
        out = SnChatMessage.fromJson(resp.data);
        _saveMessageToLocal([out]);
      } catch (_) {
        // ignore, maybe not found
      }
    }

    // Preload some related things if found
    if (out != null) {
      await _ud.listAccount([out.sender.accountId]);

      final attachments = await _attach.getMultiple(
        out.body['attachments']?.cast<String>() ?? [],
      );
      out = out.copyWith(
        preload: SnChatMessagePreload(
          attachments: attachments,
        ),
      );
    }

    return out;
  }

  /// Get message from local storage first, then from the server.
  /// Will not check local storage is up to date with the server.
  /// If you need to do the sync, do the `checkUpdate` instead.
  Future<List<SnChatMessage>> getMessages(
    int take,
    int offset, {
    bool forceLocal = false,
    bool forceRemote = false,
  }) async {
    late List<SnChatMessage> out;
    if (_box != null && (_box!.length >= take + offset || forceLocal) && !forceRemote) {
      out = _box!.keys
          .toList()
          .cast<int>()
          .sorted((a, b) => b.compareTo(a))
          .skip(offset)
          .take(take)
          .map((key) => _box!.get(key)!)
          .toList();
    } else {
      final resp = await _sn.client.get(
        '/cgi/im/channels/${channel!.keyPath}/events',
        queryParameters: {
          'take': take,
          'offset': offset,
        },
      );
      messageTotal = resp.data['count'] as int?;
      out = List<SnChatMessage>.from(
        resp.data['data']?.map((e) => SnChatMessage.fromJson(e)) ?? [],
      );
      _saveMessageToLocal(out);
    }

    // Preload attachments
    final attachmentRid = List<String>.from(
      out.expand((e) => (e.body['attachments'] as List<dynamic>?) ?? []),
    );
    final attachments = await _attach.getMultiple(attachmentRid);

    // Putting preload back to data
    for (var i = 0; i < out.length; i++) {
      // Preload related events (quoted)
      SnChatMessage? quoteEvent;
      if (out[i].quoteEventId != null) {
        quoteEvent = await getMessage(out[i].quoteEventId as int);
      }

      out[i] = out[i].copyWith(
        preload: SnChatMessagePreload(
          quoteEvent: quoteEvent,
          attachments: attachments
              .where(
                (ele) => out[i].body['attachments']?.contains(ele?.rid) ?? false,
              )
              .toList(),
        ),
      );
    }

    // Preload sender accounts
    final accountId = out.where((ele) => ele.sender.accountId >= 0).map((ele) => ele.sender.accountId).toSet();
    await _ud.listAccount(accountId);

    return out;
  }

  /// The load messages method work as same as the `getMessages` method.
  /// But it won't return the messages instead append them to the value that controller has.
  /// At the same time, this method provide the `isLoading` state.
  /// The `skip` parameter is no longer required since it will skip the messages count that already loaded.
  Future<void> loadMessages({int take = 20}) async {
    isLoading = true;
    notifyListeners();

    try {
      final out = await getMessages(take, messages.length);
      messages.addAll(out);
    } catch (err) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _box?.close();
    _wsSubscription?.cancel();
    super.dispose();
  }
}

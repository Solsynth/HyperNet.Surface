import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surface/providers/sn_network.dart';
import 'package:surface/providers/userinfo.dart';
import 'package:surface/types/websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketProvider extends ChangeNotifier {
  bool isBusy = false;
  bool isConnected = false;

  WebSocketChannel? conn;

  late final SnNetworkProvider _sn;
  late final UserProvider _ua;

  StreamController<WebSocketPackage> pk = StreamController.broadcast();
  Stream<dynamic>? _wsStream;

  WebSocketProvider(BuildContext context) {
    _sn = context.read<SnNetworkProvider>();
    _ua = context.read<UserProvider>();
  }

  Future<void> tryConnect() async {
    if (isConnected) return;
    if (!_ua.isAuthorized) return;

    log('[WebSocket] Connecting to the server...');
    await connect();
  }

  Completer<void>? _connectCompleter;

  Future<void> connect({noRetry = false}) async {
    if (_connectCompleter != null) {
      await _connectCompleter!.future;
      _connectCompleter = null;
    }

    if (!_ua.isAuthorized) return;
    if (isConnected || conn != null) {
      disconnect();
    }

    try {
      _connectCompleter = Completer<void>();

      final atk = await _sn.getFreshAtk();
      final uri = Uri.parse(
        '${_sn.client.options.baseUrl.replaceFirst('http', 'ws')}/ws?tk=$atk',
      );

      isBusy = true;
      notifyListeners();

      conn = WebSocketChannel.connect(uri);
      await conn!.ready;
      _wsStream = conn!.stream.asBroadcastStream();
      listen();
      log('[WebSocket] Connected to server!');
      isConnected = true;
    } catch (err) {
      if (err is WebSocketChannelException) {
        log('Failed to connect to websocket: ${(err.inner as dynamic).message}');
      } else {
        log('Failed to connect to websocket: $err');
      }

      if (!noRetry) {
        log('Retry connecting to websocket in 3 seconds...');
        return Future.delayed(
          const Duration(seconds: 3),
          () => connect(noRetry: true),
        );
      }
    } finally {
      isBusy = false;
      notifyListeners();
      _connectCompleter!.complete();
      _connectCompleter = null;
    }
  }

  void disconnect() {
    if (conn != null) {
      conn!.sink.close();
    }
    conn = null;
    isConnected = false;
    notifyListeners();
  }

  void listen() {
    if (_wsStream == null) return;
    _wsStream!.listen(
      (event) {
        final packet = WebSocketPackage.fromJson(jsonDecode(event));
        log('Websocket incoming message: ${packet.method} ${packet.message}');
        pk.sink.add(packet);
      },
      onDone: () {
        isConnected = false;
        notifyListeners();
        Future.delayed(const Duration(seconds: 1), () => connect());
      },
      onError: (err) {
        isConnected = false;
        notifyListeners();
        Future.delayed(const Duration(seconds: 1), () => connect());
      },
    );
  }
}

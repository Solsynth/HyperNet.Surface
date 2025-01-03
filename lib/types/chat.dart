import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:surface/types/account.dart';
import 'package:surface/types/attachment.dart';
import 'package:surface/types/realm.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
class SnChannel with _$SnChannel {
  const SnChannel._();

  @HiveType(typeId: 2)
  const factory SnChannel({
    @HiveField(0) required int id,
    @HiveField(1) required DateTime createdAt,
    @HiveField(2) required DateTime updatedAt,
    @HiveField(3) required dynamic deletedAt,
    @HiveField(4) required String alias,
    @HiveField(5) required String name,
    @HiveField(6) required String description,
    @HiveField(7) required List<SnChannelMember>? members,
    List<SnChatMessage>? messages,
    @HiveField(8) required int type,
    @HiveField(9) required int accountId,
    @HiveField(10) required SnRealm? realm,
    @HiveField(11) required int? realmId,
    @HiveField(12) required bool isPublic,
    @HiveField(13) required bool isCommunity,
  }) = _SnChannel;

  factory SnChannel.fromJson(Map<String, dynamic> json) =>
      _$SnChannelFromJson(json);

  String get key => '${realm?.alias ?? 'global'}:$alias';
  String get keyPath => '${realm?.alias ?? 'global'}/$alias';
}

@freezed
class SnChannelMember with _$SnChannelMember {
  const SnChannelMember._();

  @HiveType(typeId: 3)
  const factory SnChannelMember({
    @HiveField(0) required int id,
    @HiveField(1) required DateTime createdAt,
    @HiveField(2) required DateTime updatedAt,
    @HiveField(3) required DateTime? deletedAt,
    @HiveField(4) required int channelId,
    @HiveField(5) required int accountId,
    @HiveField(6) required String? nick,
    @HiveField(7) required SnChannel? channel,
    @HiveField(8) required SnAccount? account,
    @Default(0) int notify,
    @HiveField(9) required int powerLevel,
    dynamic calls,
    dynamic events,
  }) = _SnChannelMember;

  factory SnChannelMember.fromJson(Map<String, dynamic> json) =>
      _$SnChannelMemberFromJson(json);
}

@freezed
class SnChatMessage with _$SnChatMessage {
  const SnChatMessage._();

  @HiveType(typeId: 4)
  const factory SnChatMessage({
    @HiveField(0) required int id,
    @HiveField(1) required DateTime createdAt,
    @HiveField(2) required DateTime updatedAt,
    @HiveField(3) required DateTime? deletedAt,
    @HiveField(4) required String uuid,
    @HiveField(5) @Default({}) Map<String, dynamic> body,
    @HiveField(6) required String type,
    @HiveField(7) required SnChannel channel,
    @HiveField(8) required SnChannelMember sender,
    @HiveField(9) required int channelId,
    @HiveField(10) required int senderId,
    @HiveField(11) required int? quoteEventId,
    @HiveField(12) required int? relatedEventId,
    SnChatMessagePreload? preload,
  }) = _SnChatMessage;

  factory SnChatMessage.fromJson(Map<String, dynamic> json) =>
      _$SnChatMessageFromJson(json);
}

@freezed
class SnChatMessagePreload with _$SnChatMessagePreload {
  const SnChatMessagePreload._();

  const factory SnChatMessagePreload({
    List<SnAttachment?>? attachments,
    SnChatMessage? quoteEvent,
  }) = _SnChatMessagePreload;

  factory SnChatMessagePreload.fromJson(Map<String, dynamic> json) =>
      _$SnChatMessagePreloadFromJson(json);
}

@freezed
class SnChatCall with _$SnChatCall {
  const factory SnChatCall({
    required int id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime? deletedAt,
    required DateTime? endedAt,
    required String externalId,
    required int founderId,
    required int channelId,
    required SnChannelMember founder,
    @Default([]) List<dynamic> participants,
  }) = _SnChatCall;

  factory SnChatCall.fromJson(Map<String, dynamic> json) =>
      _$SnChatCallFromJson(json);
}

// Call stuff

enum ParticipantStatsType {
  unknown,
  localAudioSender,
  localVideoSender,
  remoteAudioReceiver,
  remoteVideoReceiver,
}

class ParticipantTrack {
  ParticipantTrack(
      {required this.participant,
      required this.videoTrack,
      required this.isScreenShare});

  VideoTrack? videoTrack;
  Participant participant;
  bool isScreenShare;
}

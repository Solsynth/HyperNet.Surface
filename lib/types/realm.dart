import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:surface/types/account.dart';

part 'realm.freezed.dart';
part 'realm.g.dart';

@freezed
class SnRealmMember with _$SnRealmMember {
  const factory SnRealmMember({
    required int id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime? deletedAt,
    required int realmId,
    required int accountId,
    required SnRealm realm,
    required SnAccount account,
    required int powerLevel,
  }) = _SnRealmMember;

  factory SnRealmMember.fromJson(Map<String, dynamic> json) =>
      _$SnRealmMemberFromJson(json);
}

@freezed
class SnRealm with _$SnRealm {
  const factory SnRealm({
    required int id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime? deletedAt,
    required String alias,
    required String name,
    required String description,
    required List<SnRealmMember>? members,
    required String? avatar,
    required String? banner,
    required Map<String, dynamic>? accessPolicy,
    required bool isPublic,
    required bool isCommunity,
    required int accountId,
  }) = _SnRealm;

  factory SnRealm.fromJson(Map<String, dynamic> json) =>
      _$SnRealmFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
class SnAccount with _$SnAccount {
  const factory SnAccount({
    required int id,
    required int? affiliatedId,
    required int? affiliatedTo,
    required int? automatedBy,
    required int? automatedId,
    required String avatar,
    required String banner,
    required DateTime? confirmedAt,
    required List<SnAccountContact> contacts,
    required DateTime createdAt,
    required DateTime? deletedAt,
    required String description,
    required String name,
    required String nick,
    required Map<String, dynamic> permNodes,
    required SnAccountProfile? profile,
    required DateTime? suspendedAt,
    required DateTime updatedAt,
  }) = _SnAccount;

  factory SnAccount.fromJson(Map<String, Object?> json) =>
      _$SnAccountFromJson(json);
}

@freezed
class SnAccountContact with _$SnAccountContact {
  const factory SnAccountContact({
    required int accountId,
    required String content,
    required DateTime createdAt,
    required DateTime? deletedAt,
    required int id,
    required bool isPrimary,
    required bool isPublic,
    required int type,
    required DateTime updatedAt,
    required DateTime? verifiedAt,
  }) = _SnAccountContact;

  factory SnAccountContact.fromJson(Map<String, Object?> json) =>
      _$SnAccountContactFromJson(json);
}

@freezed
class SnAccountProfile with _$SnAccountProfile {
  const factory SnAccountProfile({
    required int id,
    required int accountId,
    required DateTime? birthday,
    required DateTime createdAt,
    required DateTime? deletedAt,
    required int experience,
    required String firstName,
    required String lastName,
    required DateTime? lastSeenAt,
    required DateTime updatedAt,
  }) = _SnAccountProfile;

  factory SnAccountProfile.fromJson(Map<String, Object?> json) =>
      _$SnAccountProfileFromJson(json);
}

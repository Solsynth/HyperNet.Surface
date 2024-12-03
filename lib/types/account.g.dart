// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SnAccountImpl _$$SnAccountImplFromJson(Map<String, dynamic> json) =>
    _$SnAccountImpl(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      confirmedAt: json['confirmed_at'] == null
          ? null
          : DateTime.parse(json['confirmed_at'] as String),
      contacts: (json['contacts'] as List<dynamic>?)
          ?.map((e) => SnAccountContact.fromJson(e as Map<String, dynamic>))
          .toList(),
      avatar: json['avatar'] as String,
      banner: json['banner'] as String,
      description: json['description'] as String,
      name: json['name'] as String,
      nick: json['nick'] as String,
      permNodes: json['perm_nodes'] as Map<String, dynamic>,
      profile: json['profile'] == null
          ? null
          : SnAccountProfile.fromJson(json['profile'] as Map<String, dynamic>),
      badges: (json['badges'] as List<dynamic>?)
              ?.map((e) => SnAccountBadge.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      suspendedAt: json['suspended_at'] == null
          ? null
          : DateTime.parse(json['suspended_at'] as String),
      affiliatedId: (json['affiliated_id'] as num?)?.toInt(),
      affiliatedTo: (json['affiliated_to'] as num?)?.toInt(),
      automatedBy: (json['automated_by'] as num?)?.toInt(),
      automatedId: (json['automated_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SnAccountImplToJson(_$SnAccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'confirmed_at': instance.confirmedAt?.toIso8601String(),
      'contacts': instance.contacts?.map((e) => e.toJson()).toList(),
      'avatar': instance.avatar,
      'banner': instance.banner,
      'description': instance.description,
      'name': instance.name,
      'nick': instance.nick,
      'perm_nodes': instance.permNodes,
      'profile': instance.profile?.toJson(),
      'badges': instance.badges.map((e) => e.toJson()).toList(),
      'suspended_at': instance.suspendedAt?.toIso8601String(),
      'affiliated_id': instance.affiliatedId,
      'affiliated_to': instance.affiliatedTo,
      'automated_by': instance.automatedBy,
      'automated_id': instance.automatedId,
    };

_$SnAccountContactImpl _$$SnAccountContactImplFromJson(
        Map<String, dynamic> json) =>
    _$SnAccountContactImpl(
      accountId: (json['account_id'] as num).toInt(),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      id: (json['id'] as num).toInt(),
      isPrimary: json['is_primary'] as bool,
      isPublic: json['is_public'] as bool,
      type: (json['type'] as num).toInt(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      verifiedAt: json['verified_at'] == null
          ? null
          : DateTime.parse(json['verified_at'] as String),
    );

Map<String, dynamic> _$$SnAccountContactImplToJson(
        _$SnAccountContactImpl instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'id': instance.id,
      'is_primary': instance.isPrimary,
      'is_public': instance.isPublic,
      'type': instance.type,
      'updated_at': instance.updatedAt.toIso8601String(),
      'verified_at': instance.verifiedAt?.toIso8601String(),
    };

_$SnAccountProfileImpl _$$SnAccountProfileImplFromJson(
        Map<String, dynamic> json) =>
    _$SnAccountProfileImpl(
      id: (json['id'] as num).toInt(),
      accountId: (json['account_id'] as num).toInt(),
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      experience: (json['experience'] as num).toInt(),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      lastSeenAt: json['last_seen_at'] == null
          ? null
          : DateTime.parse(json['last_seen_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SnAccountProfileImplToJson(
        _$SnAccountProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account_id': instance.accountId,
      'birthday': instance.birthday?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'experience': instance.experience,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'last_seen_at': instance.lastSeenAt?.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$SnRelationshipImpl _$$SnRelationshipImplFromJson(Map<String, dynamic> json) =>
    _$SnRelationshipImpl(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      accountId: (json['account_id'] as num).toInt(),
      relatedId: (json['related_id'] as num).toInt(),
      account: json['account'] == null
          ? null
          : SnAccount.fromJson(json['account'] as Map<String, dynamic>),
      related: json['related'] == null
          ? null
          : SnAccount.fromJson(json['related'] as Map<String, dynamic>),
      status: (json['status'] as num).toInt(),
      permNodes: json['perm_nodes'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$SnRelationshipImplToJson(
        _$SnRelationshipImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'account_id': instance.accountId,
      'related_id': instance.relatedId,
      'account': instance.account?.toJson(),
      'related': instance.related?.toJson(),
      'status': instance.status,
      'perm_nodes': instance.permNodes,
    };

_$SnAccountBadgeImpl _$$SnAccountBadgeImplFromJson(Map<String, dynamic> json) =>
    _$SnAccountBadgeImpl(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'],
      type: json['type'] as String,
      accountId: (json['account_id'] as num).toInt(),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$SnAccountBadgeImplToJson(
        _$SnAccountBadgeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt,
      'type': instance.type,
      'account_id': instance.accountId,
      'metadata': instance.metadata,
    };

_$SnAccountStatusInfoImpl _$$SnAccountStatusInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$SnAccountStatusInfoImpl(
      isDisturbable: json['is_disturbable'] as bool,
      isOnline: json['is_online'] as bool,
      lastSeenAt: json['last_seen_at'] == null
          ? null
          : DateTime.parse(json['last_seen_at'] as String),
      status: json['status'],
    );

Map<String, dynamic> _$$SnAccountStatusInfoImplToJson(
        _$SnAccountStatusInfoImpl instance) =>
    <String, dynamic>{
      'is_disturbable': instance.isDisturbable,
      'is_online': instance.isOnline,
      'last_seen_at': instance.lastSeenAt?.toIso8601String(),
      'status': instance.status,
    };

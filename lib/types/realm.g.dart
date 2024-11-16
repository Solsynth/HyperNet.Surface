// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SnRealmMemberImpl _$$SnRealmMemberImplFromJson(Map<String, dynamic> json) =>
    _$SnRealmMemberImpl(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      realmId: (json['realm_id'] as num).toInt(),
      accountId: (json['account_id'] as num).toInt(),
      realm: SnRealm.fromJson(json['realm'] as Map<String, dynamic>),
      account: SnAccount.fromJson(json['account'] as Map<String, dynamic>),
      powerLevel: (json['power_level'] as num).toInt(),
    );

Map<String, dynamic> _$$SnRealmMemberImplToJson(_$SnRealmMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'realm_id': instance.realmId,
      'account_id': instance.accountId,
      'realm': instance.realm.toJson(),
      'account': instance.account.toJson(),
      'power_level': instance.powerLevel,
    };

_$SnRealmImpl _$$SnRealmImplFromJson(Map<String, dynamic> json) =>
    _$SnRealmImpl(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      alias: json['alias'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => SnRealmMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      avatar: json['avatar'] as String?,
      banner: json['banner'] as String?,
      accessPolicy: json['access_policy'] as Map<String, dynamic>?,
      isPublic: json['is_public'] as bool,
      isCommunity: json['is_community'] as bool,
      accountId: (json['account_id'] as num).toInt(),
    );

Map<String, dynamic> _$$SnRealmImplToJson(_$SnRealmImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'alias': instance.alias,
      'name': instance.name,
      'description': instance.description,
      'members': instance.members?.map((e) => e.toJson()).toList(),
      'avatar': instance.avatar,
      'banner': instance.banner,
      'access_policy': instance.accessPolicy,
      'is_public': instance.isPublic,
      'is_community': instance.isCommunity,
      'account_id': instance.accountId,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keypair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SnKeyPair _$SnKeyPairFromJson(Map<String, dynamic> json) => _SnKeyPair(
      id: json['id'] as String,
      accountId: (json['account_id'] as num).toInt(),
      publicKey: json['public_key'] as String,
      isActive: json['is_active'] as bool?,
      privateKey: json['private_key'] as String?,
    );

Map<String, dynamic> _$SnKeyPairToJson(_SnKeyPair instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account_id': instance.accountId,
      'public_key': instance.publicKey,
      'is_active': instance.isActive,
      'private_key': instance.privateKey,
    };

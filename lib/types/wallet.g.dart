// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SnWalletImpl _$$SnWalletImplFromJson(Map<String, dynamic> json) =>
    _$SnWalletImpl(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      balance: json['balance'] as String,
      password: json['password'] as String,
      accountId: (json['account_id'] as num).toInt(),
    );

Map<String, dynamic> _$$SnWalletImplToJson(_$SnWalletImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'balance': instance.balance,
      'password': instance.password,
      'account_id': instance.accountId,
    };

_$SnTransactionImpl _$$SnTransactionImplFromJson(Map<String, dynamic> json) =>
    _$SnTransactionImpl(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      remark: json['remark'] as String,
      amount: json['amount'] as String,
      payer: json['payer'] == null
          ? null
          : SnWallet.fromJson(json['payer'] as Map<String, dynamic>),
      payee: json['payee'] == null
          ? null
          : SnWallet.fromJson(json['payee'] as Map<String, dynamic>),
      payerId: (json['payer_id'] as num?)?.toInt(),
      payeeId: (json['payee_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SnTransactionImplToJson(_$SnTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'remark': instance.remark,
      'amount': instance.amount,
      'payer': instance.payer?.toJson(),
      'payee': instance.payee?.toJson(),
      'payer_id': instance.payerId,
      'payee_id': instance.payeeId,
    };

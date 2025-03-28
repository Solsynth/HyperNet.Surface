// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SnLocalChatChannelTable extends SnLocalChatChannel
    with TableInfo<$SnLocalChatChannelTable, SnLocalChatChannelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnLocalChatChannelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
      'alias', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<SnChannel, String> content =
      GeneratedColumn<String>('content', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SnChannel>($SnLocalChatChannelTable.$convertercontent);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, alias, content, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sn_local_chat_channel';
  @override
  VerificationContext validateIntegrity(
      Insertable<SnLocalChatChannelData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('alias')) {
      context.handle(
          _aliasMeta, alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta));
    } else if (isInserting) {
      context.missing(_aliasMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnLocalChatChannelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnLocalChatChannelData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      alias: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alias'])!,
      content: $SnLocalChatChannelTable.$convertercontent.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}content'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SnLocalChatChannelTable createAlias(String alias) {
    return $SnLocalChatChannelTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SnChannel, String, Map<String, Object?>>
      $convertercontent = const SnChannelConverter();
}

class SnLocalChatChannelData extends DataClass
    implements Insertable<SnLocalChatChannelData> {
  final int id;
  final String alias;
  final SnChannel content;
  final DateTime createdAt;
  const SnLocalChatChannelData(
      {required this.id,
      required this.alias,
      required this.content,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['alias'] = Variable<String>(alias);
    {
      map['content'] = Variable<String>(
          $SnLocalChatChannelTable.$convertercontent.toSql(content));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SnLocalChatChannelCompanion toCompanion(bool nullToAbsent) {
    return SnLocalChatChannelCompanion(
      id: Value(id),
      alias: Value(alias),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory SnLocalChatChannelData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnLocalChatChannelData(
      id: serializer.fromJson<int>(json['id']),
      alias: serializer.fromJson<String>(json['alias']),
      content: $SnLocalChatChannelTable.$convertercontent
          .fromJson(serializer.fromJson<Map<String, Object?>>(json['content'])),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'alias': serializer.toJson<String>(alias),
      'content': serializer.toJson<Map<String, Object?>>(
          $SnLocalChatChannelTable.$convertercontent.toJson(content)),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SnLocalChatChannelData copyWith(
          {int? id, String? alias, SnChannel? content, DateTime? createdAt}) =>
      SnLocalChatChannelData(
        id: id ?? this.id,
        alias: alias ?? this.alias,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
      );
  SnLocalChatChannelData copyWithCompanion(SnLocalChatChannelCompanion data) {
    return SnLocalChatChannelData(
      id: data.id.present ? data.id.value : this.id,
      alias: data.alias.present ? data.alias.value : this.alias,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalChatChannelData(')
          ..write('id: $id, ')
          ..write('alias: $alias, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, alias, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnLocalChatChannelData &&
          other.id == this.id &&
          other.alias == this.alias &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class SnLocalChatChannelCompanion
    extends UpdateCompanion<SnLocalChatChannelData> {
  final Value<int> id;
  final Value<String> alias;
  final Value<SnChannel> content;
  final Value<DateTime> createdAt;
  const SnLocalChatChannelCompanion({
    this.id = const Value.absent(),
    this.alias = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SnLocalChatChannelCompanion.insert({
    this.id = const Value.absent(),
    required String alias,
    required SnChannel content,
    this.createdAt = const Value.absent(),
  })  : alias = Value(alias),
        content = Value(content);
  static Insertable<SnLocalChatChannelData> custom({
    Expression<int>? id,
    Expression<String>? alias,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alias != null) 'alias': alias,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SnLocalChatChannelCompanion copyWith(
      {Value<int>? id,
      Value<String>? alias,
      Value<SnChannel>? content,
      Value<DateTime>? createdAt}) {
    return SnLocalChatChannelCompanion(
      id: id ?? this.id,
      alias: alias ?? this.alias,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(
          $SnLocalChatChannelTable.$convertercontent.toSql(content.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalChatChannelCompanion(')
          ..write('id: $id, ')
          ..write('alias: $alias, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SnLocalChatMessageTable extends SnLocalChatMessage
    with TableInfo<$SnLocalChatMessageTable, SnLocalChatMessageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnLocalChatMessageTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _channelIdMeta =
      const VerificationMeta('channelId');
  @override
  late final GeneratedColumn<int> channelId = GeneratedColumn<int>(
      'channel_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _senderIdMeta =
      const VerificationMeta('senderId');
  @override
  late final GeneratedColumn<int> senderId = GeneratedColumn<int>(
      'sender_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<SnChatMessage, String> content =
      GeneratedColumn<String>('content', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SnChatMessage>(
              $SnLocalChatMessageTable.$convertercontent);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, channelId, senderId, content, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sn_local_chat_message';
  @override
  VerificationContext validateIntegrity(
      Insertable<SnLocalChatMessageData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('channel_id')) {
      context.handle(_channelIdMeta,
          channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta));
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(_senderIdMeta,
          senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnLocalChatMessageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnLocalChatMessageData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      channelId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}channel_id'])!,
      senderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sender_id']),
      content: $SnLocalChatMessageTable.$convertercontent.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}content'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SnLocalChatMessageTable createAlias(String alias) {
    return $SnLocalChatMessageTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SnChatMessage, String, Map<String, Object?>>
      $convertercontent = const SnMessageConverter();
}

class SnLocalChatMessageData extends DataClass
    implements Insertable<SnLocalChatMessageData> {
  final int id;
  final int channelId;
  final int? senderId;
  final SnChatMessage content;
  final DateTime createdAt;
  const SnLocalChatMessageData(
      {required this.id,
      required this.channelId,
      this.senderId,
      required this.content,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['channel_id'] = Variable<int>(channelId);
    if (!nullToAbsent || senderId != null) {
      map['sender_id'] = Variable<int>(senderId);
    }
    {
      map['content'] = Variable<String>(
          $SnLocalChatMessageTable.$convertercontent.toSql(content));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SnLocalChatMessageCompanion toCompanion(bool nullToAbsent) {
    return SnLocalChatMessageCompanion(
      id: Value(id),
      channelId: Value(channelId),
      senderId: senderId == null && nullToAbsent
          ? const Value.absent()
          : Value(senderId),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory SnLocalChatMessageData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnLocalChatMessageData(
      id: serializer.fromJson<int>(json['id']),
      channelId: serializer.fromJson<int>(json['channelId']),
      senderId: serializer.fromJson<int?>(json['senderId']),
      content: $SnLocalChatMessageTable.$convertercontent
          .fromJson(serializer.fromJson<Map<String, Object?>>(json['content'])),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'channelId': serializer.toJson<int>(channelId),
      'senderId': serializer.toJson<int?>(senderId),
      'content': serializer.toJson<Map<String, Object?>>(
          $SnLocalChatMessageTable.$convertercontent.toJson(content)),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SnLocalChatMessageData copyWith(
          {int? id,
          int? channelId,
          Value<int?> senderId = const Value.absent(),
          SnChatMessage? content,
          DateTime? createdAt}) =>
      SnLocalChatMessageData(
        id: id ?? this.id,
        channelId: channelId ?? this.channelId,
        senderId: senderId.present ? senderId.value : this.senderId,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
      );
  SnLocalChatMessageData copyWithCompanion(SnLocalChatMessageCompanion data) {
    return SnLocalChatMessageData(
      id: data.id.present ? data.id.value : this.id,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalChatMessageData(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('senderId: $senderId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, channelId, senderId, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnLocalChatMessageData &&
          other.id == this.id &&
          other.channelId == this.channelId &&
          other.senderId == this.senderId &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class SnLocalChatMessageCompanion
    extends UpdateCompanion<SnLocalChatMessageData> {
  final Value<int> id;
  final Value<int> channelId;
  final Value<int?> senderId;
  final Value<SnChatMessage> content;
  final Value<DateTime> createdAt;
  const SnLocalChatMessageCompanion({
    this.id = const Value.absent(),
    this.channelId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SnLocalChatMessageCompanion.insert({
    this.id = const Value.absent(),
    required int channelId,
    this.senderId = const Value.absent(),
    required SnChatMessage content,
    this.createdAt = const Value.absent(),
  })  : channelId = Value(channelId),
        content = Value(content);
  static Insertable<SnLocalChatMessageData> custom({
    Expression<int>? id,
    Expression<int>? channelId,
    Expression<int>? senderId,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (channelId != null) 'channel_id': channelId,
      if (senderId != null) 'sender_id': senderId,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SnLocalChatMessageCompanion copyWith(
      {Value<int>? id,
      Value<int>? channelId,
      Value<int?>? senderId,
      Value<SnChatMessage>? content,
      Value<DateTime>? createdAt}) {
    return SnLocalChatMessageCompanion(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<int>(channelId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<int>(senderId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(
          $SnLocalChatMessageTable.$convertercontent.toSql(content.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalChatMessageCompanion(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('senderId: $senderId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SnLocalChannelMemberTable extends SnLocalChannelMember
    with TableInfo<$SnLocalChannelMemberTable, SnLocalChannelMemberData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnLocalChannelMemberTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _channelIdMeta =
      const VerificationMeta('channelId');
  @override
  late final GeneratedColumn<int> channelId = GeneratedColumn<int>(
      'channel_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<SnChannelMember, String> content =
      GeneratedColumn<String>('content', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SnChannelMember>(
              $SnLocalChannelMemberTable.$convertercontent);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _cacheExpiredAtMeta =
      const VerificationMeta('cacheExpiredAt');
  @override
  late final GeneratedColumn<DateTime> cacheExpiredAt =
      GeneratedColumn<DateTime>('cache_expired_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, channelId, accountId, content, createdAt, cacheExpiredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sn_local_channel_member';
  @override
  VerificationContext validateIntegrity(
      Insertable<SnLocalChannelMemberData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('channel_id')) {
      context.handle(_channelIdMeta,
          channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta));
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('cache_expired_at')) {
      context.handle(
          _cacheExpiredAtMeta,
          cacheExpiredAt.isAcceptableOrUnknown(
              data['cache_expired_at']!, _cacheExpiredAtMeta));
    } else if (isInserting) {
      context.missing(_cacheExpiredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnLocalChannelMemberData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnLocalChannelMemberData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      channelId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}channel_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      content: $SnLocalChannelMemberTable.$convertercontent.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}content'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      cacheExpiredAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}cache_expired_at'])!,
    );
  }

  @override
  $SnLocalChannelMemberTable createAlias(String alias) {
    return $SnLocalChannelMemberTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SnChannelMember, String, Map<String, Object?>>
      $convertercontent = SnChannelMemberConverter();
}

class SnLocalChannelMemberData extends DataClass
    implements Insertable<SnLocalChannelMemberData> {
  final int id;
  final int channelId;
  final int accountId;
  final SnChannelMember content;
  final DateTime createdAt;
  final DateTime cacheExpiredAt;
  const SnLocalChannelMemberData(
      {required this.id,
      required this.channelId,
      required this.accountId,
      required this.content,
      required this.createdAt,
      required this.cacheExpiredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['channel_id'] = Variable<int>(channelId);
    map['account_id'] = Variable<int>(accountId);
    {
      map['content'] = Variable<String>(
          $SnLocalChannelMemberTable.$convertercontent.toSql(content));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['cache_expired_at'] = Variable<DateTime>(cacheExpiredAt);
    return map;
  }

  SnLocalChannelMemberCompanion toCompanion(bool nullToAbsent) {
    return SnLocalChannelMemberCompanion(
      id: Value(id),
      channelId: Value(channelId),
      accountId: Value(accountId),
      content: Value(content),
      createdAt: Value(createdAt),
      cacheExpiredAt: Value(cacheExpiredAt),
    );
  }

  factory SnLocalChannelMemberData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnLocalChannelMemberData(
      id: serializer.fromJson<int>(json['id']),
      channelId: serializer.fromJson<int>(json['channelId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      content: $SnLocalChannelMemberTable.$convertercontent
          .fromJson(serializer.fromJson<Map<String, Object?>>(json['content'])),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      cacheExpiredAt: serializer.fromJson<DateTime>(json['cacheExpiredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'channelId': serializer.toJson<int>(channelId),
      'accountId': serializer.toJson<int>(accountId),
      'content': serializer.toJson<Map<String, Object?>>(
          $SnLocalChannelMemberTable.$convertercontent.toJson(content)),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'cacheExpiredAt': serializer.toJson<DateTime>(cacheExpiredAt),
    };
  }

  SnLocalChannelMemberData copyWith(
          {int? id,
          int? channelId,
          int? accountId,
          SnChannelMember? content,
          DateTime? createdAt,
          DateTime? cacheExpiredAt}) =>
      SnLocalChannelMemberData(
        id: id ?? this.id,
        channelId: channelId ?? this.channelId,
        accountId: accountId ?? this.accountId,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        cacheExpiredAt: cacheExpiredAt ?? this.cacheExpiredAt,
      );
  SnLocalChannelMemberData copyWithCompanion(
      SnLocalChannelMemberCompanion data) {
    return SnLocalChannelMemberData(
      id: data.id.present ? data.id.value : this.id,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      cacheExpiredAt: data.cacheExpiredAt.present
          ? data.cacheExpiredAt.value
          : this.cacheExpiredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalChannelMemberData(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('accountId: $accountId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('cacheExpiredAt: $cacheExpiredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, channelId, accountId, content, createdAt, cacheExpiredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnLocalChannelMemberData &&
          other.id == this.id &&
          other.channelId == this.channelId &&
          other.accountId == this.accountId &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.cacheExpiredAt == this.cacheExpiredAt);
}

class SnLocalChannelMemberCompanion
    extends UpdateCompanion<SnLocalChannelMemberData> {
  final Value<int> id;
  final Value<int> channelId;
  final Value<int> accountId;
  final Value<SnChannelMember> content;
  final Value<DateTime> createdAt;
  final Value<DateTime> cacheExpiredAt;
  const SnLocalChannelMemberCompanion({
    this.id = const Value.absent(),
    this.channelId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cacheExpiredAt = const Value.absent(),
  });
  SnLocalChannelMemberCompanion.insert({
    this.id = const Value.absent(),
    required int channelId,
    required int accountId,
    required SnChannelMember content,
    this.createdAt = const Value.absent(),
    required DateTime cacheExpiredAt,
  })  : channelId = Value(channelId),
        accountId = Value(accountId),
        content = Value(content),
        cacheExpiredAt = Value(cacheExpiredAt);
  static Insertable<SnLocalChannelMemberData> custom({
    Expression<int>? id,
    Expression<int>? channelId,
    Expression<int>? accountId,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? cacheExpiredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (channelId != null) 'channel_id': channelId,
      if (accountId != null) 'account_id': accountId,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (cacheExpiredAt != null) 'cache_expired_at': cacheExpiredAt,
    });
  }

  SnLocalChannelMemberCompanion copyWith(
      {Value<int>? id,
      Value<int>? channelId,
      Value<int>? accountId,
      Value<SnChannelMember>? content,
      Value<DateTime>? createdAt,
      Value<DateTime>? cacheExpiredAt}) {
    return SnLocalChannelMemberCompanion(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      accountId: accountId ?? this.accountId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      cacheExpiredAt: cacheExpiredAt ?? this.cacheExpiredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<int>(channelId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(
          $SnLocalChannelMemberTable.$convertercontent.toSql(content.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (cacheExpiredAt.present) {
      map['cache_expired_at'] = Variable<DateTime>(cacheExpiredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalChannelMemberCompanion(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('accountId: $accountId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('cacheExpiredAt: $cacheExpiredAt')
          ..write(')'))
        .toString();
  }
}

class $SnLocalKeyPairTable extends SnLocalKeyPair
    with TableInfo<$SnLocalKeyPairTable, SnLocalKeyPairData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnLocalKeyPairTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _publicKeyMeta =
      const VerificationMeta('publicKey');
  @override
  late final GeneratedColumn<String> publicKey = GeneratedColumn<String>(
      'public_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _privateKeyMeta =
      const VerificationMeta('privateKey');
  @override
  late final GeneratedColumn<String> privateKey = GeneratedColumn<String>(
      'private_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, accountId, publicKey, privateKey, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sn_local_key_pair';
  @override
  VerificationContext validateIntegrity(Insertable<SnLocalKeyPairData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('public_key')) {
      context.handle(_publicKeyMeta,
          publicKey.isAcceptableOrUnknown(data['public_key']!, _publicKeyMeta));
    } else if (isInserting) {
      context.missing(_publicKeyMeta);
    }
    if (data.containsKey('private_key')) {
      context.handle(
          _privateKeyMeta,
          privateKey.isAcceptableOrUnknown(
              data['private_key']!, _privateKeyMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnLocalKeyPairData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnLocalKeyPairData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      publicKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}public_key'])!,
      privateKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}private_key']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $SnLocalKeyPairTable createAlias(String alias) {
    return $SnLocalKeyPairTable(attachedDatabase, alias);
  }
}

class SnLocalKeyPairData extends DataClass
    implements Insertable<SnLocalKeyPairData> {
  final String id;
  final int accountId;
  final String publicKey;
  final String? privateKey;
  final bool isActive;
  const SnLocalKeyPairData(
      {required this.id,
      required this.accountId,
      required this.publicKey,
      this.privateKey,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<int>(accountId);
    map['public_key'] = Variable<String>(publicKey);
    if (!nullToAbsent || privateKey != null) {
      map['private_key'] = Variable<String>(privateKey);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SnLocalKeyPairCompanion toCompanion(bool nullToAbsent) {
    return SnLocalKeyPairCompanion(
      id: Value(id),
      accountId: Value(accountId),
      publicKey: Value(publicKey),
      privateKey: privateKey == null && nullToAbsent
          ? const Value.absent()
          : Value(privateKey),
      isActive: Value(isActive),
    );
  }

  factory SnLocalKeyPairData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnLocalKeyPairData(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      publicKey: serializer.fromJson<String>(json['publicKey']),
      privateKey: serializer.fromJson<String?>(json['privateKey']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<int>(accountId),
      'publicKey': serializer.toJson<String>(publicKey),
      'privateKey': serializer.toJson<String?>(privateKey),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  SnLocalKeyPairData copyWith(
          {String? id,
          int? accountId,
          String? publicKey,
          Value<String?> privateKey = const Value.absent(),
          bool? isActive}) =>
      SnLocalKeyPairData(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        publicKey: publicKey ?? this.publicKey,
        privateKey: privateKey.present ? privateKey.value : this.privateKey,
        isActive: isActive ?? this.isActive,
      );
  SnLocalKeyPairData copyWithCompanion(SnLocalKeyPairCompanion data) {
    return SnLocalKeyPairData(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      publicKey: data.publicKey.present ? data.publicKey.value : this.publicKey,
      privateKey:
          data.privateKey.present ? data.privateKey.value : this.privateKey,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalKeyPairData(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('publicKey: $publicKey, ')
          ..write('privateKey: $privateKey, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, accountId, publicKey, privateKey, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnLocalKeyPairData &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.publicKey == this.publicKey &&
          other.privateKey == this.privateKey &&
          other.isActive == this.isActive);
}

class SnLocalKeyPairCompanion extends UpdateCompanion<SnLocalKeyPairData> {
  final Value<String> id;
  final Value<int> accountId;
  final Value<String> publicKey;
  final Value<String?> privateKey;
  final Value<bool> isActive;
  final Value<int> rowid;
  const SnLocalKeyPairCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.publicKey = const Value.absent(),
    this.privateKey = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SnLocalKeyPairCompanion.insert({
    required String id,
    required int accountId,
    required String publicKey,
    this.privateKey = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        accountId = Value(accountId),
        publicKey = Value(publicKey);
  static Insertable<SnLocalKeyPairData> custom({
    Expression<String>? id,
    Expression<int>? accountId,
    Expression<String>? publicKey,
    Expression<String>? privateKey,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (publicKey != null) 'public_key': publicKey,
      if (privateKey != null) 'private_key': privateKey,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SnLocalKeyPairCompanion copyWith(
      {Value<String>? id,
      Value<int>? accountId,
      Value<String>? publicKey,
      Value<String?>? privateKey,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return SnLocalKeyPairCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      publicKey: publicKey ?? this.publicKey,
      privateKey: privateKey ?? this.privateKey,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (publicKey.present) {
      map['public_key'] = Variable<String>(publicKey.value);
    }
    if (privateKey.present) {
      map['private_key'] = Variable<String>(privateKey.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalKeyPairCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('publicKey: $publicKey, ')
          ..write('privateKey: $privateKey, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SnLocalAccountTable extends SnLocalAccount
    with TableInfo<$SnLocalAccountTable, SnLocalAccountData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnLocalAccountTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<SnAccount, String> content =
      GeneratedColumn<String>('content', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SnAccount>($SnLocalAccountTable.$convertercontent);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _cacheExpiredAtMeta =
      const VerificationMeta('cacheExpiredAt');
  @override
  late final GeneratedColumn<DateTime> cacheExpiredAt =
      GeneratedColumn<DateTime>('cache_expired_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, content, createdAt, cacheExpiredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sn_local_account';
  @override
  VerificationContext validateIntegrity(Insertable<SnLocalAccountData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('cache_expired_at')) {
      context.handle(
          _cacheExpiredAtMeta,
          cacheExpiredAt.isAcceptableOrUnknown(
              data['cache_expired_at']!, _cacheExpiredAtMeta));
    } else if (isInserting) {
      context.missing(_cacheExpiredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnLocalAccountData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnLocalAccountData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      content: $SnLocalAccountTable.$convertercontent.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      cacheExpiredAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}cache_expired_at'])!,
    );
  }

  @override
  $SnLocalAccountTable createAlias(String alias) {
    return $SnLocalAccountTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SnAccount, String, Map<String, Object?>>
      $convertercontent = const SnAccountConverter();
}

class SnLocalAccountData extends DataClass
    implements Insertable<SnLocalAccountData> {
  final int id;
  final String name;
  final SnAccount content;
  final DateTime createdAt;
  final DateTime cacheExpiredAt;
  const SnLocalAccountData(
      {required this.id,
      required this.name,
      required this.content,
      required this.createdAt,
      required this.cacheExpiredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['content'] = Variable<String>(
          $SnLocalAccountTable.$convertercontent.toSql(content));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['cache_expired_at'] = Variable<DateTime>(cacheExpiredAt);
    return map;
  }

  SnLocalAccountCompanion toCompanion(bool nullToAbsent) {
    return SnLocalAccountCompanion(
      id: Value(id),
      name: Value(name),
      content: Value(content),
      createdAt: Value(createdAt),
      cacheExpiredAt: Value(cacheExpiredAt),
    );
  }

  factory SnLocalAccountData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnLocalAccountData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      content: $SnLocalAccountTable.$convertercontent
          .fromJson(serializer.fromJson<Map<String, Object?>>(json['content'])),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      cacheExpiredAt: serializer.fromJson<DateTime>(json['cacheExpiredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'content': serializer.toJson<Map<String, Object?>>(
          $SnLocalAccountTable.$convertercontent.toJson(content)),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'cacheExpiredAt': serializer.toJson<DateTime>(cacheExpiredAt),
    };
  }

  SnLocalAccountData copyWith(
          {int? id,
          String? name,
          SnAccount? content,
          DateTime? createdAt,
          DateTime? cacheExpiredAt}) =>
      SnLocalAccountData(
        id: id ?? this.id,
        name: name ?? this.name,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        cacheExpiredAt: cacheExpiredAt ?? this.cacheExpiredAt,
      );
  SnLocalAccountData copyWithCompanion(SnLocalAccountCompanion data) {
    return SnLocalAccountData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      cacheExpiredAt: data.cacheExpiredAt.present
          ? data.cacheExpiredAt.value
          : this.cacheExpiredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalAccountData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('cacheExpiredAt: $cacheExpiredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, content, createdAt, cacheExpiredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnLocalAccountData &&
          other.id == this.id &&
          other.name == this.name &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.cacheExpiredAt == this.cacheExpiredAt);
}

class SnLocalAccountCompanion extends UpdateCompanion<SnLocalAccountData> {
  final Value<int> id;
  final Value<String> name;
  final Value<SnAccount> content;
  final Value<DateTime> createdAt;
  final Value<DateTime> cacheExpiredAt;
  const SnLocalAccountCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cacheExpiredAt = const Value.absent(),
  });
  SnLocalAccountCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required SnAccount content,
    this.createdAt = const Value.absent(),
    required DateTime cacheExpiredAt,
  })  : name = Value(name),
        content = Value(content),
        cacheExpiredAt = Value(cacheExpiredAt);
  static Insertable<SnLocalAccountData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? cacheExpiredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (cacheExpiredAt != null) 'cache_expired_at': cacheExpiredAt,
    });
  }

  SnLocalAccountCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<SnAccount>? content,
      Value<DateTime>? createdAt,
      Value<DateTime>? cacheExpiredAt}) {
    return SnLocalAccountCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      cacheExpiredAt: cacheExpiredAt ?? this.cacheExpiredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(
          $SnLocalAccountTable.$convertercontent.toSql(content.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (cacheExpiredAt.present) {
      map['cache_expired_at'] = Variable<DateTime>(cacheExpiredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalAccountCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('cacheExpiredAt: $cacheExpiredAt')
          ..write(')'))
        .toString();
  }
}

class $SnLocalAttachmentTable extends SnLocalAttachment
    with TableInfo<$SnLocalAttachmentTable, SnLocalAttachmentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnLocalAttachmentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ridMeta = const VerificationMeta('rid');
  @override
  late final GeneratedColumn<String> rid = GeneratedColumn<String>(
      'rid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumnWithTypeConverter<SnAttachment, String> content =
      GeneratedColumn<String>('content', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SnAttachment>(
              $SnLocalAttachmentTable.$convertercontent);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _cacheExpiredAtMeta =
      const VerificationMeta('cacheExpiredAt');
  @override
  late final GeneratedColumn<DateTime> cacheExpiredAt =
      GeneratedColumn<DateTime>('cache_expired_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, rid, uuid, content, accountId, createdAt, cacheExpiredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sn_local_attachment';
  @override
  VerificationContext validateIntegrity(
      Insertable<SnLocalAttachmentData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('rid')) {
      context.handle(
          _ridMeta, rid.isAcceptableOrUnknown(data['rid']!, _ridMeta));
    } else if (isInserting) {
      context.missing(_ridMeta);
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('cache_expired_at')) {
      context.handle(
          _cacheExpiredAtMeta,
          cacheExpiredAt.isAcceptableOrUnknown(
              data['cache_expired_at']!, _cacheExpiredAtMeta));
    } else if (isInserting) {
      context.missing(_cacheExpiredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnLocalAttachmentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnLocalAttachmentData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      rid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rid'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      content: $SnLocalAttachmentTable.$convertercontent.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}content'])!),
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      cacheExpiredAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}cache_expired_at'])!,
    );
  }

  @override
  $SnLocalAttachmentTable createAlias(String alias) {
    return $SnLocalAttachmentTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SnAttachment, String, Map<String, Object?>>
      $convertercontent = const SnAttachmentConverter();
}

class SnLocalAttachmentData extends DataClass
    implements Insertable<SnLocalAttachmentData> {
  final int id;
  final String rid;
  final String uuid;
  final SnAttachment content;
  final int accountId;
  final DateTime createdAt;
  final DateTime cacheExpiredAt;
  const SnLocalAttachmentData(
      {required this.id,
      required this.rid,
      required this.uuid,
      required this.content,
      required this.accountId,
      required this.createdAt,
      required this.cacheExpiredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['rid'] = Variable<String>(rid);
    map['uuid'] = Variable<String>(uuid);
    {
      map['content'] = Variable<String>(
          $SnLocalAttachmentTable.$convertercontent.toSql(content));
    }
    map['account_id'] = Variable<int>(accountId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['cache_expired_at'] = Variable<DateTime>(cacheExpiredAt);
    return map;
  }

  SnLocalAttachmentCompanion toCompanion(bool nullToAbsent) {
    return SnLocalAttachmentCompanion(
      id: Value(id),
      rid: Value(rid),
      uuid: Value(uuid),
      content: Value(content),
      accountId: Value(accountId),
      createdAt: Value(createdAt),
      cacheExpiredAt: Value(cacheExpiredAt),
    );
  }

  factory SnLocalAttachmentData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnLocalAttachmentData(
      id: serializer.fromJson<int>(json['id']),
      rid: serializer.fromJson<String>(json['rid']),
      uuid: serializer.fromJson<String>(json['uuid']),
      content: $SnLocalAttachmentTable.$convertercontent
          .fromJson(serializer.fromJson<Map<String, Object?>>(json['content'])),
      accountId: serializer.fromJson<int>(json['accountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      cacheExpiredAt: serializer.fromJson<DateTime>(json['cacheExpiredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'rid': serializer.toJson<String>(rid),
      'uuid': serializer.toJson<String>(uuid),
      'content': serializer.toJson<Map<String, Object?>>(
          $SnLocalAttachmentTable.$convertercontent.toJson(content)),
      'accountId': serializer.toJson<int>(accountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'cacheExpiredAt': serializer.toJson<DateTime>(cacheExpiredAt),
    };
  }

  SnLocalAttachmentData copyWith(
          {int? id,
          String? rid,
          String? uuid,
          SnAttachment? content,
          int? accountId,
          DateTime? createdAt,
          DateTime? cacheExpiredAt}) =>
      SnLocalAttachmentData(
        id: id ?? this.id,
        rid: rid ?? this.rid,
        uuid: uuid ?? this.uuid,
        content: content ?? this.content,
        accountId: accountId ?? this.accountId,
        createdAt: createdAt ?? this.createdAt,
        cacheExpiredAt: cacheExpiredAt ?? this.cacheExpiredAt,
      );
  SnLocalAttachmentData copyWithCompanion(SnLocalAttachmentCompanion data) {
    return SnLocalAttachmentData(
      id: data.id.present ? data.id.value : this.id,
      rid: data.rid.present ? data.rid.value : this.rid,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      content: data.content.present ? data.content.value : this.content,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      cacheExpiredAt: data.cacheExpiredAt.present
          ? data.cacheExpiredAt.value
          : this.cacheExpiredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalAttachmentData(')
          ..write('id: $id, ')
          ..write('rid: $rid, ')
          ..write('uuid: $uuid, ')
          ..write('content: $content, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('cacheExpiredAt: $cacheExpiredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, rid, uuid, content, accountId, createdAt, cacheExpiredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnLocalAttachmentData &&
          other.id == this.id &&
          other.rid == this.rid &&
          other.uuid == this.uuid &&
          other.content == this.content &&
          other.accountId == this.accountId &&
          other.createdAt == this.createdAt &&
          other.cacheExpiredAt == this.cacheExpiredAt);
}

class SnLocalAttachmentCompanion
    extends UpdateCompanion<SnLocalAttachmentData> {
  final Value<int> id;
  final Value<String> rid;
  final Value<String> uuid;
  final Value<SnAttachment> content;
  final Value<int> accountId;
  final Value<DateTime> createdAt;
  final Value<DateTime> cacheExpiredAt;
  const SnLocalAttachmentCompanion({
    this.id = const Value.absent(),
    this.rid = const Value.absent(),
    this.uuid = const Value.absent(),
    this.content = const Value.absent(),
    this.accountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cacheExpiredAt = const Value.absent(),
  });
  SnLocalAttachmentCompanion.insert({
    this.id = const Value.absent(),
    required String rid,
    required String uuid,
    required SnAttachment content,
    required int accountId,
    this.createdAt = const Value.absent(),
    required DateTime cacheExpiredAt,
  })  : rid = Value(rid),
        uuid = Value(uuid),
        content = Value(content),
        accountId = Value(accountId),
        cacheExpiredAt = Value(cacheExpiredAt);
  static Insertable<SnLocalAttachmentData> custom({
    Expression<int>? id,
    Expression<String>? rid,
    Expression<String>? uuid,
    Expression<String>? content,
    Expression<int>? accountId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? cacheExpiredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rid != null) 'rid': rid,
      if (uuid != null) 'uuid': uuid,
      if (content != null) 'content': content,
      if (accountId != null) 'account_id': accountId,
      if (createdAt != null) 'created_at': createdAt,
      if (cacheExpiredAt != null) 'cache_expired_at': cacheExpiredAt,
    });
  }

  SnLocalAttachmentCompanion copyWith(
      {Value<int>? id,
      Value<String>? rid,
      Value<String>? uuid,
      Value<SnAttachment>? content,
      Value<int>? accountId,
      Value<DateTime>? createdAt,
      Value<DateTime>? cacheExpiredAt}) {
    return SnLocalAttachmentCompanion(
      id: id ?? this.id,
      rid: rid ?? this.rid,
      uuid: uuid ?? this.uuid,
      content: content ?? this.content,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
      cacheExpiredAt: cacheExpiredAt ?? this.cacheExpiredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (rid.present) {
      map['rid'] = Variable<String>(rid.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(
          $SnLocalAttachmentTable.$convertercontent.toSql(content.value));
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (cacheExpiredAt.present) {
      map['cache_expired_at'] = Variable<DateTime>(cacheExpiredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalAttachmentCompanion(')
          ..write('id: $id, ')
          ..write('rid: $rid, ')
          ..write('uuid: $uuid, ')
          ..write('content: $content, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('cacheExpiredAt: $cacheExpiredAt')
          ..write(')'))
        .toString();
  }
}

class $SnLocalStickerTable extends SnLocalSticker
    with TableInfo<$SnLocalStickerTable, SnLocalStickerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnLocalStickerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
      'alias', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullAliasMeta =
      const VerificationMeta('fullAlias');
  @override
  late final GeneratedColumn<String> fullAlias = GeneratedColumn<String>(
      'full_alias', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<SnSticker, String> content =
      GeneratedColumn<String>('content', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SnSticker>($SnLocalStickerTable.$convertercontent);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, alias, fullAlias, content, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sn_local_sticker';
  @override
  VerificationContext validateIntegrity(Insertable<SnLocalStickerData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('alias')) {
      context.handle(
          _aliasMeta, alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta));
    } else if (isInserting) {
      context.missing(_aliasMeta);
    }
    if (data.containsKey('full_alias')) {
      context.handle(_fullAliasMeta,
          fullAlias.isAcceptableOrUnknown(data['full_alias']!, _fullAliasMeta));
    } else if (isInserting) {
      context.missing(_fullAliasMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnLocalStickerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnLocalStickerData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      alias: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alias'])!,
      fullAlias: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_alias'])!,
      content: $SnLocalStickerTable.$convertercontent.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SnLocalStickerTable createAlias(String alias) {
    return $SnLocalStickerTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SnSticker, String, Map<String, Object?>>
      $convertercontent = const SnStickerConverter();
}

class SnLocalStickerData extends DataClass
    implements Insertable<SnLocalStickerData> {
  final int id;
  final String alias;
  final String fullAlias;
  final SnSticker content;
  final DateTime createdAt;
  const SnLocalStickerData(
      {required this.id,
      required this.alias,
      required this.fullAlias,
      required this.content,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['alias'] = Variable<String>(alias);
    map['full_alias'] = Variable<String>(fullAlias);
    {
      map['content'] = Variable<String>(
          $SnLocalStickerTable.$convertercontent.toSql(content));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SnLocalStickerCompanion toCompanion(bool nullToAbsent) {
    return SnLocalStickerCompanion(
      id: Value(id),
      alias: Value(alias),
      fullAlias: Value(fullAlias),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory SnLocalStickerData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnLocalStickerData(
      id: serializer.fromJson<int>(json['id']),
      alias: serializer.fromJson<String>(json['alias']),
      fullAlias: serializer.fromJson<String>(json['fullAlias']),
      content: $SnLocalStickerTable.$convertercontent
          .fromJson(serializer.fromJson<Map<String, Object?>>(json['content'])),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'alias': serializer.toJson<String>(alias),
      'fullAlias': serializer.toJson<String>(fullAlias),
      'content': serializer.toJson<Map<String, Object?>>(
          $SnLocalStickerTable.$convertercontent.toJson(content)),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SnLocalStickerData copyWith(
          {int? id,
          String? alias,
          String? fullAlias,
          SnSticker? content,
          DateTime? createdAt}) =>
      SnLocalStickerData(
        id: id ?? this.id,
        alias: alias ?? this.alias,
        fullAlias: fullAlias ?? this.fullAlias,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
      );
  SnLocalStickerData copyWithCompanion(SnLocalStickerCompanion data) {
    return SnLocalStickerData(
      id: data.id.present ? data.id.value : this.id,
      alias: data.alias.present ? data.alias.value : this.alias,
      fullAlias: data.fullAlias.present ? data.fullAlias.value : this.fullAlias,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalStickerData(')
          ..write('id: $id, ')
          ..write('alias: $alias, ')
          ..write('fullAlias: $fullAlias, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, alias, fullAlias, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnLocalStickerData &&
          other.id == this.id &&
          other.alias == this.alias &&
          other.fullAlias == this.fullAlias &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class SnLocalStickerCompanion extends UpdateCompanion<SnLocalStickerData> {
  final Value<int> id;
  final Value<String> alias;
  final Value<String> fullAlias;
  final Value<SnSticker> content;
  final Value<DateTime> createdAt;
  const SnLocalStickerCompanion({
    this.id = const Value.absent(),
    this.alias = const Value.absent(),
    this.fullAlias = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SnLocalStickerCompanion.insert({
    this.id = const Value.absent(),
    required String alias,
    required String fullAlias,
    required SnSticker content,
    this.createdAt = const Value.absent(),
  })  : alias = Value(alias),
        fullAlias = Value(fullAlias),
        content = Value(content);
  static Insertable<SnLocalStickerData> custom({
    Expression<int>? id,
    Expression<String>? alias,
    Expression<String>? fullAlias,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alias != null) 'alias': alias,
      if (fullAlias != null) 'full_alias': fullAlias,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SnLocalStickerCompanion copyWith(
      {Value<int>? id,
      Value<String>? alias,
      Value<String>? fullAlias,
      Value<SnSticker>? content,
      Value<DateTime>? createdAt}) {
    return SnLocalStickerCompanion(
      id: id ?? this.id,
      alias: alias ?? this.alias,
      fullAlias: fullAlias ?? this.fullAlias,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (fullAlias.present) {
      map['full_alias'] = Variable<String>(fullAlias.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(
          $SnLocalStickerTable.$convertercontent.toSql(content.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalStickerCompanion(')
          ..write('id: $id, ')
          ..write('alias: $alias, ')
          ..write('fullAlias: $fullAlias, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SnLocalStickerPackTable extends SnLocalStickerPack
    with TableInfo<$SnLocalStickerPackTable, SnLocalStickerPackData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnLocalStickerPackTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumnWithTypeConverter<SnStickerPack, String> content =
      GeneratedColumn<String>('content', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SnStickerPack>(
              $SnLocalStickerPackTable.$convertercontent);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, content, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sn_local_sticker_pack';
  @override
  VerificationContext validateIntegrity(
      Insertable<SnLocalStickerPackData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnLocalStickerPackData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnLocalStickerPackData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      content: $SnLocalStickerPackTable.$convertercontent.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}content'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SnLocalStickerPackTable createAlias(String alias) {
    return $SnLocalStickerPackTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SnStickerPack, String, Map<String, Object?>>
      $convertercontent = const SnStickerPackConverter();
}

class SnLocalStickerPackData extends DataClass
    implements Insertable<SnLocalStickerPackData> {
  final int id;
  final SnStickerPack content;
  final DateTime createdAt;
  const SnLocalStickerPackData(
      {required this.id, required this.content, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['content'] = Variable<String>(
          $SnLocalStickerPackTable.$convertercontent.toSql(content));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SnLocalStickerPackCompanion toCompanion(bool nullToAbsent) {
    return SnLocalStickerPackCompanion(
      id: Value(id),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory SnLocalStickerPackData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnLocalStickerPackData(
      id: serializer.fromJson<int>(json['id']),
      content: $SnLocalStickerPackTable.$convertercontent
          .fromJson(serializer.fromJson<Map<String, Object?>>(json['content'])),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<Map<String, Object?>>(
          $SnLocalStickerPackTable.$convertercontent.toJson(content)),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SnLocalStickerPackData copyWith(
          {int? id, SnStickerPack? content, DateTime? createdAt}) =>
      SnLocalStickerPackData(
        id: id ?? this.id,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
      );
  SnLocalStickerPackData copyWithCompanion(SnLocalStickerPackCompanion data) {
    return SnLocalStickerPackData(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalStickerPackData(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnLocalStickerPackData &&
          other.id == this.id &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class SnLocalStickerPackCompanion
    extends UpdateCompanion<SnLocalStickerPackData> {
  final Value<int> id;
  final Value<SnStickerPack> content;
  final Value<DateTime> createdAt;
  const SnLocalStickerPackCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SnLocalStickerPackCompanion.insert({
    this.id = const Value.absent(),
    required SnStickerPack content,
    this.createdAt = const Value.absent(),
  }) : content = Value(content);
  static Insertable<SnLocalStickerPackData> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SnLocalStickerPackCompanion copyWith(
      {Value<int>? id,
      Value<SnStickerPack>? content,
      Value<DateTime>? createdAt}) {
    return SnLocalStickerPackCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(
          $SnLocalStickerPackTable.$convertercontent.toSql(content.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalStickerPackCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SnLocalRealmTable extends SnLocalRealm
    with TableInfo<$SnLocalRealmTable, SnLocalRealmData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnLocalRealmTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
      'alias', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  late final GeneratedColumnWithTypeConverter<SnRealm, String> content =
      GeneratedColumn<String>('content', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SnRealm>($SnLocalRealmTable.$convertercontent);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _cacheExpiredAtMeta =
      const VerificationMeta('cacheExpiredAt');
  @override
  late final GeneratedColumn<DateTime> cacheExpiredAt =
      GeneratedColumn<DateTime>('cache_expired_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, alias, content, accountId, createdAt, cacheExpiredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sn_local_realm';
  @override
  VerificationContext validateIntegrity(Insertable<SnLocalRealmData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('alias')) {
      context.handle(
          _aliasMeta, alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta));
    } else if (isInserting) {
      context.missing(_aliasMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('cache_expired_at')) {
      context.handle(
          _cacheExpiredAtMeta,
          cacheExpiredAt.isAcceptableOrUnknown(
              data['cache_expired_at']!, _cacheExpiredAtMeta));
    } else if (isInserting) {
      context.missing(_cacheExpiredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnLocalRealmData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnLocalRealmData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      alias: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alias'])!,
      content: $SnLocalRealmTable.$convertercontent.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!),
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      cacheExpiredAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}cache_expired_at'])!,
    );
  }

  @override
  $SnLocalRealmTable createAlias(String alias) {
    return $SnLocalRealmTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SnRealm, String, Map<String, Object?>>
      $convertercontent = const SnRealmConverter();
}

class SnLocalRealmData extends DataClass
    implements Insertable<SnLocalRealmData> {
  final int id;
  final String alias;
  final SnRealm content;
  final int accountId;
  final DateTime createdAt;
  final DateTime cacheExpiredAt;
  const SnLocalRealmData(
      {required this.id,
      required this.alias,
      required this.content,
      required this.accountId,
      required this.createdAt,
      required this.cacheExpiredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['alias'] = Variable<String>(alias);
    {
      map['content'] =
          Variable<String>($SnLocalRealmTable.$convertercontent.toSql(content));
    }
    map['account_id'] = Variable<int>(accountId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['cache_expired_at'] = Variable<DateTime>(cacheExpiredAt);
    return map;
  }

  SnLocalRealmCompanion toCompanion(bool nullToAbsent) {
    return SnLocalRealmCompanion(
      id: Value(id),
      alias: Value(alias),
      content: Value(content),
      accountId: Value(accountId),
      createdAt: Value(createdAt),
      cacheExpiredAt: Value(cacheExpiredAt),
    );
  }

  factory SnLocalRealmData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnLocalRealmData(
      id: serializer.fromJson<int>(json['id']),
      alias: serializer.fromJson<String>(json['alias']),
      content: $SnLocalRealmTable.$convertercontent
          .fromJson(serializer.fromJson<Map<String, Object?>>(json['content'])),
      accountId: serializer.fromJson<int>(json['accountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      cacheExpiredAt: serializer.fromJson<DateTime>(json['cacheExpiredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'alias': serializer.toJson<String>(alias),
      'content': serializer.toJson<Map<String, Object?>>(
          $SnLocalRealmTable.$convertercontent.toJson(content)),
      'accountId': serializer.toJson<int>(accountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'cacheExpiredAt': serializer.toJson<DateTime>(cacheExpiredAt),
    };
  }

  SnLocalRealmData copyWith(
          {int? id,
          String? alias,
          SnRealm? content,
          int? accountId,
          DateTime? createdAt,
          DateTime? cacheExpiredAt}) =>
      SnLocalRealmData(
        id: id ?? this.id,
        alias: alias ?? this.alias,
        content: content ?? this.content,
        accountId: accountId ?? this.accountId,
        createdAt: createdAt ?? this.createdAt,
        cacheExpiredAt: cacheExpiredAt ?? this.cacheExpiredAt,
      );
  SnLocalRealmData copyWithCompanion(SnLocalRealmCompanion data) {
    return SnLocalRealmData(
      id: data.id.present ? data.id.value : this.id,
      alias: data.alias.present ? data.alias.value : this.alias,
      content: data.content.present ? data.content.value : this.content,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      cacheExpiredAt: data.cacheExpiredAt.present
          ? data.cacheExpiredAt.value
          : this.cacheExpiredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalRealmData(')
          ..write('id: $id, ')
          ..write('alias: $alias, ')
          ..write('content: $content, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('cacheExpiredAt: $cacheExpiredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, alias, content, accountId, createdAt, cacheExpiredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnLocalRealmData &&
          other.id == this.id &&
          other.alias == this.alias &&
          other.content == this.content &&
          other.accountId == this.accountId &&
          other.createdAt == this.createdAt &&
          other.cacheExpiredAt == this.cacheExpiredAt);
}

class SnLocalRealmCompanion extends UpdateCompanion<SnLocalRealmData> {
  final Value<int> id;
  final Value<String> alias;
  final Value<SnRealm> content;
  final Value<int> accountId;
  final Value<DateTime> createdAt;
  final Value<DateTime> cacheExpiredAt;
  const SnLocalRealmCompanion({
    this.id = const Value.absent(),
    this.alias = const Value.absent(),
    this.content = const Value.absent(),
    this.accountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cacheExpiredAt = const Value.absent(),
  });
  SnLocalRealmCompanion.insert({
    this.id = const Value.absent(),
    required String alias,
    required SnRealm content,
    required int accountId,
    this.createdAt = const Value.absent(),
    required DateTime cacheExpiredAt,
  })  : alias = Value(alias),
        content = Value(content),
        accountId = Value(accountId),
        cacheExpiredAt = Value(cacheExpiredAt);
  static Insertable<SnLocalRealmData> custom({
    Expression<int>? id,
    Expression<String>? alias,
    Expression<String>? content,
    Expression<int>? accountId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? cacheExpiredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alias != null) 'alias': alias,
      if (content != null) 'content': content,
      if (accountId != null) 'account_id': accountId,
      if (createdAt != null) 'created_at': createdAt,
      if (cacheExpiredAt != null) 'cache_expired_at': cacheExpiredAt,
    });
  }

  SnLocalRealmCompanion copyWith(
      {Value<int>? id,
      Value<String>? alias,
      Value<SnRealm>? content,
      Value<int>? accountId,
      Value<DateTime>? createdAt,
      Value<DateTime>? cacheExpiredAt}) {
    return SnLocalRealmCompanion(
      id: id ?? this.id,
      alias: alias ?? this.alias,
      content: content ?? this.content,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
      cacheExpiredAt: cacheExpiredAt ?? this.cacheExpiredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(
          $SnLocalRealmTable.$convertercontent.toSql(content.value));
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (cacheExpiredAt.present) {
      map['cache_expired_at'] = Variable<DateTime>(cacheExpiredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnLocalRealmCompanion(')
          ..write('id: $id, ')
          ..write('alias: $alias, ')
          ..write('content: $content, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('cacheExpiredAt: $cacheExpiredAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SnLocalChatChannelTable snLocalChatChannel =
      $SnLocalChatChannelTable(this);
  late final $SnLocalChatMessageTable snLocalChatMessage =
      $SnLocalChatMessageTable(this);
  late final $SnLocalChannelMemberTable snLocalChannelMember =
      $SnLocalChannelMemberTable(this);
  late final $SnLocalKeyPairTable snLocalKeyPair = $SnLocalKeyPairTable(this);
  late final $SnLocalAccountTable snLocalAccount = $SnLocalAccountTable(this);
  late final $SnLocalAttachmentTable snLocalAttachment =
      $SnLocalAttachmentTable(this);
  late final $SnLocalStickerTable snLocalSticker = $SnLocalStickerTable(this);
  late final $SnLocalStickerPackTable snLocalStickerPack =
      $SnLocalStickerPackTable(this);
  late final $SnLocalRealmTable snLocalRealm = $SnLocalRealmTable(this);
  late final Index idxChannelAlias = Index('idx_channel_alias',
      'CREATE INDEX idx_channel_alias ON sn_local_chat_channel (alias)');
  late final Index idxChatChannel = Index('idx_chat_channel',
      'CREATE INDEX idx_chat_channel ON sn_local_chat_message (channel_id)');
  late final Index idxAccountName = Index('idx_account_name',
      'CREATE INDEX idx_account_name ON sn_local_account (name)');
  late final Index idxAttachmentRid = Index('idx_attachment_rid',
      'CREATE INDEX idx_attachment_rid ON sn_local_attachment (rid)');
  late final Index idxAttachmentAccount = Index('idx_attachment_account',
      'CREATE INDEX idx_attachment_account ON sn_local_attachment (account_id)');
  late final Index idxRealmAlias = Index('idx_realm_alias',
      'CREATE INDEX idx_realm_alias ON sn_local_realm (alias)');
  late final Index idxRealmAccount = Index('idx_realm_account',
      'CREATE INDEX idx_realm_account ON sn_local_realm (account_id)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        snLocalChatChannel,
        snLocalChatMessage,
        snLocalChannelMember,
        snLocalKeyPair,
        snLocalAccount,
        snLocalAttachment,
        snLocalSticker,
        snLocalStickerPack,
        snLocalRealm,
        idxChannelAlias,
        idxChatChannel,
        idxAccountName,
        idxAttachmentRid,
        idxAttachmentAccount,
        idxRealmAlias,
        idxRealmAccount
      ];
}

typedef $$SnLocalChatChannelTableCreateCompanionBuilder
    = SnLocalChatChannelCompanion Function({
  Value<int> id,
  required String alias,
  required SnChannel content,
  Value<DateTime> createdAt,
});
typedef $$SnLocalChatChannelTableUpdateCompanionBuilder
    = SnLocalChatChannelCompanion Function({
  Value<int> id,
  Value<String> alias,
  Value<SnChannel> content,
  Value<DateTime> createdAt,
});

class $$SnLocalChatChannelTableFilterComposer
    extends Composer<_$AppDatabase, $SnLocalChatChannelTable> {
  $$SnLocalChatChannelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SnChannel, SnChannel, String> get content =>
      $composableBuilder(
          column: $table.content,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SnLocalChatChannelTableOrderingComposer
    extends Composer<_$AppDatabase, $SnLocalChatChannelTable> {
  $$SnLocalChatChannelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SnLocalChatChannelTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnLocalChatChannelTable> {
  $$SnLocalChatChannelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SnChannel, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SnLocalChatChannelTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SnLocalChatChannelTable,
    SnLocalChatChannelData,
    $$SnLocalChatChannelTableFilterComposer,
    $$SnLocalChatChannelTableOrderingComposer,
    $$SnLocalChatChannelTableAnnotationComposer,
    $$SnLocalChatChannelTableCreateCompanionBuilder,
    $$SnLocalChatChannelTableUpdateCompanionBuilder,
    (
      SnLocalChatChannelData,
      BaseReferences<_$AppDatabase, $SnLocalChatChannelTable,
          SnLocalChatChannelData>
    ),
    SnLocalChatChannelData,
    PrefetchHooks Function()> {
  $$SnLocalChatChannelTableTableManager(
      _$AppDatabase db, $SnLocalChatChannelTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnLocalChatChannelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnLocalChatChannelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnLocalChatChannelTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> alias = const Value.absent(),
            Value<SnChannel> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SnLocalChatChannelCompanion(
            id: id,
            alias: alias,
            content: content,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String alias,
            required SnChannel content,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SnLocalChatChannelCompanion.insert(
            id: id,
            alias: alias,
            content: content,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SnLocalChatChannelTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SnLocalChatChannelTable,
    SnLocalChatChannelData,
    $$SnLocalChatChannelTableFilterComposer,
    $$SnLocalChatChannelTableOrderingComposer,
    $$SnLocalChatChannelTableAnnotationComposer,
    $$SnLocalChatChannelTableCreateCompanionBuilder,
    $$SnLocalChatChannelTableUpdateCompanionBuilder,
    (
      SnLocalChatChannelData,
      BaseReferences<_$AppDatabase, $SnLocalChatChannelTable,
          SnLocalChatChannelData>
    ),
    SnLocalChatChannelData,
    PrefetchHooks Function()>;
typedef $$SnLocalChatMessageTableCreateCompanionBuilder
    = SnLocalChatMessageCompanion Function({
  Value<int> id,
  required int channelId,
  Value<int?> senderId,
  required SnChatMessage content,
  Value<DateTime> createdAt,
});
typedef $$SnLocalChatMessageTableUpdateCompanionBuilder
    = SnLocalChatMessageCompanion Function({
  Value<int> id,
  Value<int> channelId,
  Value<int?> senderId,
  Value<SnChatMessage> content,
  Value<DateTime> createdAt,
});

class $$SnLocalChatMessageTableFilterComposer
    extends Composer<_$AppDatabase, $SnLocalChatMessageTable> {
  $$SnLocalChatMessageTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get channelId => $composableBuilder(
      column: $table.channelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get senderId => $composableBuilder(
      column: $table.senderId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SnChatMessage, SnChatMessage, String>
      get content => $composableBuilder(
          column: $table.content,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SnLocalChatMessageTableOrderingComposer
    extends Composer<_$AppDatabase, $SnLocalChatMessageTable> {
  $$SnLocalChatMessageTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get channelId => $composableBuilder(
      column: $table.channelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get senderId => $composableBuilder(
      column: $table.senderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SnLocalChatMessageTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnLocalChatMessageTable> {
  $$SnLocalChatMessageTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<int> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SnChatMessage, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SnLocalChatMessageTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SnLocalChatMessageTable,
    SnLocalChatMessageData,
    $$SnLocalChatMessageTableFilterComposer,
    $$SnLocalChatMessageTableOrderingComposer,
    $$SnLocalChatMessageTableAnnotationComposer,
    $$SnLocalChatMessageTableCreateCompanionBuilder,
    $$SnLocalChatMessageTableUpdateCompanionBuilder,
    (
      SnLocalChatMessageData,
      BaseReferences<_$AppDatabase, $SnLocalChatMessageTable,
          SnLocalChatMessageData>
    ),
    SnLocalChatMessageData,
    PrefetchHooks Function()> {
  $$SnLocalChatMessageTableTableManager(
      _$AppDatabase db, $SnLocalChatMessageTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnLocalChatMessageTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnLocalChatMessageTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnLocalChatMessageTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> channelId = const Value.absent(),
            Value<int?> senderId = const Value.absent(),
            Value<SnChatMessage> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SnLocalChatMessageCompanion(
            id: id,
            channelId: channelId,
            senderId: senderId,
            content: content,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int channelId,
            Value<int?> senderId = const Value.absent(),
            required SnChatMessage content,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SnLocalChatMessageCompanion.insert(
            id: id,
            channelId: channelId,
            senderId: senderId,
            content: content,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SnLocalChatMessageTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SnLocalChatMessageTable,
    SnLocalChatMessageData,
    $$SnLocalChatMessageTableFilterComposer,
    $$SnLocalChatMessageTableOrderingComposer,
    $$SnLocalChatMessageTableAnnotationComposer,
    $$SnLocalChatMessageTableCreateCompanionBuilder,
    $$SnLocalChatMessageTableUpdateCompanionBuilder,
    (
      SnLocalChatMessageData,
      BaseReferences<_$AppDatabase, $SnLocalChatMessageTable,
          SnLocalChatMessageData>
    ),
    SnLocalChatMessageData,
    PrefetchHooks Function()>;
typedef $$SnLocalChannelMemberTableCreateCompanionBuilder
    = SnLocalChannelMemberCompanion Function({
  Value<int> id,
  required int channelId,
  required int accountId,
  required SnChannelMember content,
  Value<DateTime> createdAt,
  required DateTime cacheExpiredAt,
});
typedef $$SnLocalChannelMemberTableUpdateCompanionBuilder
    = SnLocalChannelMemberCompanion Function({
  Value<int> id,
  Value<int> channelId,
  Value<int> accountId,
  Value<SnChannelMember> content,
  Value<DateTime> createdAt,
  Value<DateTime> cacheExpiredAt,
});

class $$SnLocalChannelMemberTableFilterComposer
    extends Composer<_$AppDatabase, $SnLocalChannelMemberTable> {
  $$SnLocalChannelMemberTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get channelId => $composableBuilder(
      column: $table.channelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SnChannelMember, SnChannelMember, String>
      get content => $composableBuilder(
          column: $table.content,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cacheExpiredAt => $composableBuilder(
      column: $table.cacheExpiredAt,
      builder: (column) => ColumnFilters(column));
}

class $$SnLocalChannelMemberTableOrderingComposer
    extends Composer<_$AppDatabase, $SnLocalChannelMemberTable> {
  $$SnLocalChannelMemberTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get channelId => $composableBuilder(
      column: $table.channelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cacheExpiredAt => $composableBuilder(
      column: $table.cacheExpiredAt,
      builder: (column) => ColumnOrderings(column));
}

class $$SnLocalChannelMemberTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnLocalChannelMemberTable> {
  $$SnLocalChannelMemberTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SnChannelMember, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cacheExpiredAt => $composableBuilder(
      column: $table.cacheExpiredAt, builder: (column) => column);
}

class $$SnLocalChannelMemberTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SnLocalChannelMemberTable,
    SnLocalChannelMemberData,
    $$SnLocalChannelMemberTableFilterComposer,
    $$SnLocalChannelMemberTableOrderingComposer,
    $$SnLocalChannelMemberTableAnnotationComposer,
    $$SnLocalChannelMemberTableCreateCompanionBuilder,
    $$SnLocalChannelMemberTableUpdateCompanionBuilder,
    (
      SnLocalChannelMemberData,
      BaseReferences<_$AppDatabase, $SnLocalChannelMemberTable,
          SnLocalChannelMemberData>
    ),
    SnLocalChannelMemberData,
    PrefetchHooks Function()> {
  $$SnLocalChannelMemberTableTableManager(
      _$AppDatabase db, $SnLocalChannelMemberTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnLocalChannelMemberTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnLocalChannelMemberTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnLocalChannelMemberTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> channelId = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<SnChannelMember> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> cacheExpiredAt = const Value.absent(),
          }) =>
              SnLocalChannelMemberCompanion(
            id: id,
            channelId: channelId,
            accountId: accountId,
            content: content,
            createdAt: createdAt,
            cacheExpiredAt: cacheExpiredAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int channelId,
            required int accountId,
            required SnChannelMember content,
            Value<DateTime> createdAt = const Value.absent(),
            required DateTime cacheExpiredAt,
          }) =>
              SnLocalChannelMemberCompanion.insert(
            id: id,
            channelId: channelId,
            accountId: accountId,
            content: content,
            createdAt: createdAt,
            cacheExpiredAt: cacheExpiredAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SnLocalChannelMemberTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $SnLocalChannelMemberTable,
        SnLocalChannelMemberData,
        $$SnLocalChannelMemberTableFilterComposer,
        $$SnLocalChannelMemberTableOrderingComposer,
        $$SnLocalChannelMemberTableAnnotationComposer,
        $$SnLocalChannelMemberTableCreateCompanionBuilder,
        $$SnLocalChannelMemberTableUpdateCompanionBuilder,
        (
          SnLocalChannelMemberData,
          BaseReferences<_$AppDatabase, $SnLocalChannelMemberTable,
              SnLocalChannelMemberData>
        ),
        SnLocalChannelMemberData,
        PrefetchHooks Function()>;
typedef $$SnLocalKeyPairTableCreateCompanionBuilder = SnLocalKeyPairCompanion
    Function({
  required String id,
  required int accountId,
  required String publicKey,
  Value<String?> privateKey,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$SnLocalKeyPairTableUpdateCompanionBuilder = SnLocalKeyPairCompanion
    Function({
  Value<String> id,
  Value<int> accountId,
  Value<String> publicKey,
  Value<String?> privateKey,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$SnLocalKeyPairTableFilterComposer
    extends Composer<_$AppDatabase, $SnLocalKeyPairTable> {
  $$SnLocalKeyPairTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get publicKey => $composableBuilder(
      column: $table.publicKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get privateKey => $composableBuilder(
      column: $table.privateKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$SnLocalKeyPairTableOrderingComposer
    extends Composer<_$AppDatabase, $SnLocalKeyPairTable> {
  $$SnLocalKeyPairTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get publicKey => $composableBuilder(
      column: $table.publicKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get privateKey => $composableBuilder(
      column: $table.privateKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$SnLocalKeyPairTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnLocalKeyPairTable> {
  $$SnLocalKeyPairTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get publicKey =>
      $composableBuilder(column: $table.publicKey, builder: (column) => column);

  GeneratedColumn<String> get privateKey => $composableBuilder(
      column: $table.privateKey, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$SnLocalKeyPairTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SnLocalKeyPairTable,
    SnLocalKeyPairData,
    $$SnLocalKeyPairTableFilterComposer,
    $$SnLocalKeyPairTableOrderingComposer,
    $$SnLocalKeyPairTableAnnotationComposer,
    $$SnLocalKeyPairTableCreateCompanionBuilder,
    $$SnLocalKeyPairTableUpdateCompanionBuilder,
    (
      SnLocalKeyPairData,
      BaseReferences<_$AppDatabase, $SnLocalKeyPairTable, SnLocalKeyPairData>
    ),
    SnLocalKeyPairData,
    PrefetchHooks Function()> {
  $$SnLocalKeyPairTableTableManager(
      _$AppDatabase db, $SnLocalKeyPairTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnLocalKeyPairTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnLocalKeyPairTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnLocalKeyPairTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<String> publicKey = const Value.absent(),
            Value<String?> privateKey = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SnLocalKeyPairCompanion(
            id: id,
            accountId: accountId,
            publicKey: publicKey,
            privateKey: privateKey,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int accountId,
            required String publicKey,
            Value<String?> privateKey = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SnLocalKeyPairCompanion.insert(
            id: id,
            accountId: accountId,
            publicKey: publicKey,
            privateKey: privateKey,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SnLocalKeyPairTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SnLocalKeyPairTable,
    SnLocalKeyPairData,
    $$SnLocalKeyPairTableFilterComposer,
    $$SnLocalKeyPairTableOrderingComposer,
    $$SnLocalKeyPairTableAnnotationComposer,
    $$SnLocalKeyPairTableCreateCompanionBuilder,
    $$SnLocalKeyPairTableUpdateCompanionBuilder,
    (
      SnLocalKeyPairData,
      BaseReferences<_$AppDatabase, $SnLocalKeyPairTable, SnLocalKeyPairData>
    ),
    SnLocalKeyPairData,
    PrefetchHooks Function()>;
typedef $$SnLocalAccountTableCreateCompanionBuilder = SnLocalAccountCompanion
    Function({
  Value<int> id,
  required String name,
  required SnAccount content,
  Value<DateTime> createdAt,
  required DateTime cacheExpiredAt,
});
typedef $$SnLocalAccountTableUpdateCompanionBuilder = SnLocalAccountCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<SnAccount> content,
  Value<DateTime> createdAt,
  Value<DateTime> cacheExpiredAt,
});

class $$SnLocalAccountTableFilterComposer
    extends Composer<_$AppDatabase, $SnLocalAccountTable> {
  $$SnLocalAccountTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SnAccount, SnAccount, String> get content =>
      $composableBuilder(
          column: $table.content,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cacheExpiredAt => $composableBuilder(
      column: $table.cacheExpiredAt,
      builder: (column) => ColumnFilters(column));
}

class $$SnLocalAccountTableOrderingComposer
    extends Composer<_$AppDatabase, $SnLocalAccountTable> {
  $$SnLocalAccountTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cacheExpiredAt => $composableBuilder(
      column: $table.cacheExpiredAt,
      builder: (column) => ColumnOrderings(column));
}

class $$SnLocalAccountTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnLocalAccountTable> {
  $$SnLocalAccountTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SnAccount, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cacheExpiredAt => $composableBuilder(
      column: $table.cacheExpiredAt, builder: (column) => column);
}

class $$SnLocalAccountTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SnLocalAccountTable,
    SnLocalAccountData,
    $$SnLocalAccountTableFilterComposer,
    $$SnLocalAccountTableOrderingComposer,
    $$SnLocalAccountTableAnnotationComposer,
    $$SnLocalAccountTableCreateCompanionBuilder,
    $$SnLocalAccountTableUpdateCompanionBuilder,
    (
      SnLocalAccountData,
      BaseReferences<_$AppDatabase, $SnLocalAccountTable, SnLocalAccountData>
    ),
    SnLocalAccountData,
    PrefetchHooks Function()> {
  $$SnLocalAccountTableTableManager(
      _$AppDatabase db, $SnLocalAccountTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnLocalAccountTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnLocalAccountTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnLocalAccountTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<SnAccount> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> cacheExpiredAt = const Value.absent(),
          }) =>
              SnLocalAccountCompanion(
            id: id,
            name: name,
            content: content,
            createdAt: createdAt,
            cacheExpiredAt: cacheExpiredAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required SnAccount content,
            Value<DateTime> createdAt = const Value.absent(),
            required DateTime cacheExpiredAt,
          }) =>
              SnLocalAccountCompanion.insert(
            id: id,
            name: name,
            content: content,
            createdAt: createdAt,
            cacheExpiredAt: cacheExpiredAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SnLocalAccountTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SnLocalAccountTable,
    SnLocalAccountData,
    $$SnLocalAccountTableFilterComposer,
    $$SnLocalAccountTableOrderingComposer,
    $$SnLocalAccountTableAnnotationComposer,
    $$SnLocalAccountTableCreateCompanionBuilder,
    $$SnLocalAccountTableUpdateCompanionBuilder,
    (
      SnLocalAccountData,
      BaseReferences<_$AppDatabase, $SnLocalAccountTable, SnLocalAccountData>
    ),
    SnLocalAccountData,
    PrefetchHooks Function()>;
typedef $$SnLocalAttachmentTableCreateCompanionBuilder
    = SnLocalAttachmentCompanion Function({
  Value<int> id,
  required String rid,
  required String uuid,
  required SnAttachment content,
  required int accountId,
  Value<DateTime> createdAt,
  required DateTime cacheExpiredAt,
});
typedef $$SnLocalAttachmentTableUpdateCompanionBuilder
    = SnLocalAttachmentCompanion Function({
  Value<int> id,
  Value<String> rid,
  Value<String> uuid,
  Value<SnAttachment> content,
  Value<int> accountId,
  Value<DateTime> createdAt,
  Value<DateTime> cacheExpiredAt,
});

class $$SnLocalAttachmentTableFilterComposer
    extends Composer<_$AppDatabase, $SnLocalAttachmentTable> {
  $$SnLocalAttachmentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rid => $composableBuilder(
      column: $table.rid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SnAttachment, SnAttachment, String>
      get content => $composableBuilder(
          column: $table.content,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cacheExpiredAt => $composableBuilder(
      column: $table.cacheExpiredAt,
      builder: (column) => ColumnFilters(column));
}

class $$SnLocalAttachmentTableOrderingComposer
    extends Composer<_$AppDatabase, $SnLocalAttachmentTable> {
  $$SnLocalAttachmentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rid => $composableBuilder(
      column: $table.rid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cacheExpiredAt => $composableBuilder(
      column: $table.cacheExpiredAt,
      builder: (column) => ColumnOrderings(column));
}

class $$SnLocalAttachmentTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnLocalAttachmentTable> {
  $$SnLocalAttachmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rid =>
      $composableBuilder(column: $table.rid, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SnAttachment, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cacheExpiredAt => $composableBuilder(
      column: $table.cacheExpiredAt, builder: (column) => column);
}

class $$SnLocalAttachmentTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SnLocalAttachmentTable,
    SnLocalAttachmentData,
    $$SnLocalAttachmentTableFilterComposer,
    $$SnLocalAttachmentTableOrderingComposer,
    $$SnLocalAttachmentTableAnnotationComposer,
    $$SnLocalAttachmentTableCreateCompanionBuilder,
    $$SnLocalAttachmentTableUpdateCompanionBuilder,
    (
      SnLocalAttachmentData,
      BaseReferences<_$AppDatabase, $SnLocalAttachmentTable,
          SnLocalAttachmentData>
    ),
    SnLocalAttachmentData,
    PrefetchHooks Function()> {
  $$SnLocalAttachmentTableTableManager(
      _$AppDatabase db, $SnLocalAttachmentTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnLocalAttachmentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnLocalAttachmentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnLocalAttachmentTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> rid = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<SnAttachment> content = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> cacheExpiredAt = const Value.absent(),
          }) =>
              SnLocalAttachmentCompanion(
            id: id,
            rid: rid,
            uuid: uuid,
            content: content,
            accountId: accountId,
            createdAt: createdAt,
            cacheExpiredAt: cacheExpiredAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String rid,
            required String uuid,
            required SnAttachment content,
            required int accountId,
            Value<DateTime> createdAt = const Value.absent(),
            required DateTime cacheExpiredAt,
          }) =>
              SnLocalAttachmentCompanion.insert(
            id: id,
            rid: rid,
            uuid: uuid,
            content: content,
            accountId: accountId,
            createdAt: createdAt,
            cacheExpiredAt: cacheExpiredAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SnLocalAttachmentTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SnLocalAttachmentTable,
    SnLocalAttachmentData,
    $$SnLocalAttachmentTableFilterComposer,
    $$SnLocalAttachmentTableOrderingComposer,
    $$SnLocalAttachmentTableAnnotationComposer,
    $$SnLocalAttachmentTableCreateCompanionBuilder,
    $$SnLocalAttachmentTableUpdateCompanionBuilder,
    (
      SnLocalAttachmentData,
      BaseReferences<_$AppDatabase, $SnLocalAttachmentTable,
          SnLocalAttachmentData>
    ),
    SnLocalAttachmentData,
    PrefetchHooks Function()>;
typedef $$SnLocalStickerTableCreateCompanionBuilder = SnLocalStickerCompanion
    Function({
  Value<int> id,
  required String alias,
  required String fullAlias,
  required SnSticker content,
  Value<DateTime> createdAt,
});
typedef $$SnLocalStickerTableUpdateCompanionBuilder = SnLocalStickerCompanion
    Function({
  Value<int> id,
  Value<String> alias,
  Value<String> fullAlias,
  Value<SnSticker> content,
  Value<DateTime> createdAt,
});

class $$SnLocalStickerTableFilterComposer
    extends Composer<_$AppDatabase, $SnLocalStickerTable> {
  $$SnLocalStickerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullAlias => $composableBuilder(
      column: $table.fullAlias, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SnSticker, SnSticker, String> get content =>
      $composableBuilder(
          column: $table.content,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SnLocalStickerTableOrderingComposer
    extends Composer<_$AppDatabase, $SnLocalStickerTable> {
  $$SnLocalStickerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullAlias => $composableBuilder(
      column: $table.fullAlias, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SnLocalStickerTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnLocalStickerTable> {
  $$SnLocalStickerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<String> get fullAlias =>
      $composableBuilder(column: $table.fullAlias, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SnSticker, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SnLocalStickerTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SnLocalStickerTable,
    SnLocalStickerData,
    $$SnLocalStickerTableFilterComposer,
    $$SnLocalStickerTableOrderingComposer,
    $$SnLocalStickerTableAnnotationComposer,
    $$SnLocalStickerTableCreateCompanionBuilder,
    $$SnLocalStickerTableUpdateCompanionBuilder,
    (
      SnLocalStickerData,
      BaseReferences<_$AppDatabase, $SnLocalStickerTable, SnLocalStickerData>
    ),
    SnLocalStickerData,
    PrefetchHooks Function()> {
  $$SnLocalStickerTableTableManager(
      _$AppDatabase db, $SnLocalStickerTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnLocalStickerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnLocalStickerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnLocalStickerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> alias = const Value.absent(),
            Value<String> fullAlias = const Value.absent(),
            Value<SnSticker> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SnLocalStickerCompanion(
            id: id,
            alias: alias,
            fullAlias: fullAlias,
            content: content,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String alias,
            required String fullAlias,
            required SnSticker content,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SnLocalStickerCompanion.insert(
            id: id,
            alias: alias,
            fullAlias: fullAlias,
            content: content,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SnLocalStickerTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SnLocalStickerTable,
    SnLocalStickerData,
    $$SnLocalStickerTableFilterComposer,
    $$SnLocalStickerTableOrderingComposer,
    $$SnLocalStickerTableAnnotationComposer,
    $$SnLocalStickerTableCreateCompanionBuilder,
    $$SnLocalStickerTableUpdateCompanionBuilder,
    (
      SnLocalStickerData,
      BaseReferences<_$AppDatabase, $SnLocalStickerTable, SnLocalStickerData>
    ),
    SnLocalStickerData,
    PrefetchHooks Function()>;
typedef $$SnLocalStickerPackTableCreateCompanionBuilder
    = SnLocalStickerPackCompanion Function({
  Value<int> id,
  required SnStickerPack content,
  Value<DateTime> createdAt,
});
typedef $$SnLocalStickerPackTableUpdateCompanionBuilder
    = SnLocalStickerPackCompanion Function({
  Value<int> id,
  Value<SnStickerPack> content,
  Value<DateTime> createdAt,
});

class $$SnLocalStickerPackTableFilterComposer
    extends Composer<_$AppDatabase, $SnLocalStickerPackTable> {
  $$SnLocalStickerPackTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SnStickerPack, SnStickerPack, String>
      get content => $composableBuilder(
          column: $table.content,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SnLocalStickerPackTableOrderingComposer
    extends Composer<_$AppDatabase, $SnLocalStickerPackTable> {
  $$SnLocalStickerPackTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SnLocalStickerPackTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnLocalStickerPackTable> {
  $$SnLocalStickerPackTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SnStickerPack, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SnLocalStickerPackTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SnLocalStickerPackTable,
    SnLocalStickerPackData,
    $$SnLocalStickerPackTableFilterComposer,
    $$SnLocalStickerPackTableOrderingComposer,
    $$SnLocalStickerPackTableAnnotationComposer,
    $$SnLocalStickerPackTableCreateCompanionBuilder,
    $$SnLocalStickerPackTableUpdateCompanionBuilder,
    (
      SnLocalStickerPackData,
      BaseReferences<_$AppDatabase, $SnLocalStickerPackTable,
          SnLocalStickerPackData>
    ),
    SnLocalStickerPackData,
    PrefetchHooks Function()> {
  $$SnLocalStickerPackTableTableManager(
      _$AppDatabase db, $SnLocalStickerPackTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnLocalStickerPackTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnLocalStickerPackTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnLocalStickerPackTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<SnStickerPack> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SnLocalStickerPackCompanion(
            id: id,
            content: content,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required SnStickerPack content,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SnLocalStickerPackCompanion.insert(
            id: id,
            content: content,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SnLocalStickerPackTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SnLocalStickerPackTable,
    SnLocalStickerPackData,
    $$SnLocalStickerPackTableFilterComposer,
    $$SnLocalStickerPackTableOrderingComposer,
    $$SnLocalStickerPackTableAnnotationComposer,
    $$SnLocalStickerPackTableCreateCompanionBuilder,
    $$SnLocalStickerPackTableUpdateCompanionBuilder,
    (
      SnLocalStickerPackData,
      BaseReferences<_$AppDatabase, $SnLocalStickerPackTable,
          SnLocalStickerPackData>
    ),
    SnLocalStickerPackData,
    PrefetchHooks Function()>;
typedef $$SnLocalRealmTableCreateCompanionBuilder = SnLocalRealmCompanion
    Function({
  Value<int> id,
  required String alias,
  required SnRealm content,
  required int accountId,
  Value<DateTime> createdAt,
  required DateTime cacheExpiredAt,
});
typedef $$SnLocalRealmTableUpdateCompanionBuilder = SnLocalRealmCompanion
    Function({
  Value<int> id,
  Value<String> alias,
  Value<SnRealm> content,
  Value<int> accountId,
  Value<DateTime> createdAt,
  Value<DateTime> cacheExpiredAt,
});

class $$SnLocalRealmTableFilterComposer
    extends Composer<_$AppDatabase, $SnLocalRealmTable> {
  $$SnLocalRealmTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SnRealm, SnRealm, String> get content =>
      $composableBuilder(
          column: $table.content,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cacheExpiredAt => $composableBuilder(
      column: $table.cacheExpiredAt,
      builder: (column) => ColumnFilters(column));
}

class $$SnLocalRealmTableOrderingComposer
    extends Composer<_$AppDatabase, $SnLocalRealmTable> {
  $$SnLocalRealmTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cacheExpiredAt => $composableBuilder(
      column: $table.cacheExpiredAt,
      builder: (column) => ColumnOrderings(column));
}

class $$SnLocalRealmTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnLocalRealmTable> {
  $$SnLocalRealmTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SnRealm, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cacheExpiredAt => $composableBuilder(
      column: $table.cacheExpiredAt, builder: (column) => column);
}

class $$SnLocalRealmTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SnLocalRealmTable,
    SnLocalRealmData,
    $$SnLocalRealmTableFilterComposer,
    $$SnLocalRealmTableOrderingComposer,
    $$SnLocalRealmTableAnnotationComposer,
    $$SnLocalRealmTableCreateCompanionBuilder,
    $$SnLocalRealmTableUpdateCompanionBuilder,
    (
      SnLocalRealmData,
      BaseReferences<_$AppDatabase, $SnLocalRealmTable, SnLocalRealmData>
    ),
    SnLocalRealmData,
    PrefetchHooks Function()> {
  $$SnLocalRealmTableTableManager(_$AppDatabase db, $SnLocalRealmTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnLocalRealmTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnLocalRealmTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnLocalRealmTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> alias = const Value.absent(),
            Value<SnRealm> content = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> cacheExpiredAt = const Value.absent(),
          }) =>
              SnLocalRealmCompanion(
            id: id,
            alias: alias,
            content: content,
            accountId: accountId,
            createdAt: createdAt,
            cacheExpiredAt: cacheExpiredAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String alias,
            required SnRealm content,
            required int accountId,
            Value<DateTime> createdAt = const Value.absent(),
            required DateTime cacheExpiredAt,
          }) =>
              SnLocalRealmCompanion.insert(
            id: id,
            alias: alias,
            content: content,
            accountId: accountId,
            createdAt: createdAt,
            cacheExpiredAt: cacheExpiredAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SnLocalRealmTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SnLocalRealmTable,
    SnLocalRealmData,
    $$SnLocalRealmTableFilterComposer,
    $$SnLocalRealmTableOrderingComposer,
    $$SnLocalRealmTableAnnotationComposer,
    $$SnLocalRealmTableCreateCompanionBuilder,
    $$SnLocalRealmTableUpdateCompanionBuilder,
    (
      SnLocalRealmData,
      BaseReferences<_$AppDatabase, $SnLocalRealmTable, SnLocalRealmData>
    ),
    SnLocalRealmData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SnLocalChatChannelTableTableManager get snLocalChatChannel =>
      $$SnLocalChatChannelTableTableManager(_db, _db.snLocalChatChannel);
  $$SnLocalChatMessageTableTableManager get snLocalChatMessage =>
      $$SnLocalChatMessageTableTableManager(_db, _db.snLocalChatMessage);
  $$SnLocalChannelMemberTableTableManager get snLocalChannelMember =>
      $$SnLocalChannelMemberTableTableManager(_db, _db.snLocalChannelMember);
  $$SnLocalKeyPairTableTableManager get snLocalKeyPair =>
      $$SnLocalKeyPairTableTableManager(_db, _db.snLocalKeyPair);
  $$SnLocalAccountTableTableManager get snLocalAccount =>
      $$SnLocalAccountTableTableManager(_db, _db.snLocalAccount);
  $$SnLocalAttachmentTableTableManager get snLocalAttachment =>
      $$SnLocalAttachmentTableTableManager(_db, _db.snLocalAttachment);
  $$SnLocalStickerTableTableManager get snLocalSticker =>
      $$SnLocalStickerTableTableManager(_db, _db.snLocalSticker);
  $$SnLocalStickerPackTableTableManager get snLocalStickerPack =>
      $$SnLocalStickerPackTableTableManager(_db, _db.snLocalStickerPack);
  $$SnLocalRealmTableTableManager get snLocalRealm =>
      $$SnLocalRealmTableTableManager(_db, _db.snLocalRealm);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SnNewsSourceImpl _$$SnNewsSourceImplFromJson(Map<String, dynamic> json) =>
    _$SnNewsSourceImpl(
      id: json['id'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      source: json['source'] as String,
      depth: (json['depth'] as num).toInt(),
      enabled: json['enabled'] as bool,
    );

Map<String, dynamic> _$$SnNewsSourceImplToJson(_$SnNewsSourceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'type': instance.type,
      'source': instance.source,
      'depth': instance.depth,
      'enabled': instance.enabled,
    };

_$SnNewsArticleImpl _$$SnNewsArticleImplFromJson(Map<String, dynamic> json) =>
    _$SnNewsArticleImpl(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'],
      thumbnail: json['thumbnail'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      url: json['url'] as String,
      hash: json['hash'] as String,
      source: json['source'] as String,
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
    );

Map<String, dynamic> _$$SnNewsArticleImplToJson(_$SnNewsArticleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt,
      'thumbnail': instance.thumbnail,
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'url': instance.url,
      'hash': instance.hash,
      'source': instance.source,
      'published_at': instance.publishedAt?.toIso8601String(),
    };

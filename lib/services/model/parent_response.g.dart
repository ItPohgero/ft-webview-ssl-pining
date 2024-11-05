// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParentResponse _$ParentResponseFromJson(Map<String, dynamic> json) =>
    ParentResponse(
      responseCode: (json['responseCode'] as num?)?.toInt(),
      responseTime: json['responseTime'] as String?,
      data: json['data'],
      totalElement: (json['totalElement'] as num?)?.toInt(),
      totalPage: (json['totalPage'] as num?)?.toInt(),
      currentPage: (json['currentPage'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ParentResponseToJson(ParentResponse instance) =>
    <String, dynamic>{
      'responseCode': instance.responseCode,
      'responseTime': instance.responseTime,
      'data': instance.data,
      'totalElement': instance.totalElement,
      'totalPage': instance.totalPage,
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
    };

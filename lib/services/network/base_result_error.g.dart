// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_result_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseRespError _$BaseRespErrorFromJson(Map<String, dynamic> json) =>
    BaseRespError()
      ..error = json['error'] == null
          ? null
          : RespError.fromJson(json['error'] as Map<String, dynamic>)
      ..detail = json['detail'] as String?
      ..msg = json['msg'] as String?;

Map<String, dynamic> _$BaseRespErrorToJson(BaseRespError instance) =>
    <String, dynamic>{
      'error': instance.error,
      'detail': instance.detail,
      'msg': instance.msg,
    };

RespError _$RespErrorFromJson(Map<String, dynamic> json) =>
    RespError()..message = json['message'] as String?;

Map<String, dynamic> _$RespErrorToJson(RespError instance) => <String, dynamic>{
  'message': instance.message,
};

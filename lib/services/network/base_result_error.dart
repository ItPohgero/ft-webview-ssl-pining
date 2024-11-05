import 'package:json_annotation/json_annotation.dart';

part 'base_result_error.g.dart';

@JsonSerializable()
class BaseRespError {
  RespError? error;
  String? detail;
  String? msg;

  BaseRespError();

  factory BaseRespError.fromJson(Map<String, dynamic> json) =>
      _$BaseRespErrorFromJson(json);
}

@JsonSerializable()
class RespError {
  String? message;

  RespError();

  factory RespError.fromJson(Map<String, dynamic> json) =>
      _$RespErrorFromJson(json);
}

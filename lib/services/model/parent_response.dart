import 'package:json_annotation/json_annotation.dart';

part 'parent_response.g.dart';

@JsonSerializable()
class ParentResponse {
  int? responseCode;
  String? responseTime;
  dynamic data;
  int? totalElement;
  int? totalPage;
  int? currentPage;
  int? pageSize;

  ParentResponse({
    this.responseCode,
    this.responseTime,
    this.data,
    this.totalElement,
    this.totalPage,
    this.currentPage,
    this.pageSize,
  });

  factory ParentResponse.fromJson(Map<String, dynamic> json) =>
      _$ParentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParentResponseToJson(this);
}

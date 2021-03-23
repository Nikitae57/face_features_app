import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

@JsonSerializable()
class ApiError {
  ApiError(this.type, this.message);

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return _$ApiErrorFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ApiErrorToJson(this);
  }

  @JsonKey(name: 'type')
  final int type;

  @JsonKey(name: 'message')
  final String message;
}

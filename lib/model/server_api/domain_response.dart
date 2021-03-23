import 'dart:convert';

import 'package:face_features/model/server_api/response/api_error.dart';
import 'package:face_features/model/server_api/response/celeb_similarity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'domain_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class DomainResponse<T> {
  DomainResponse(this.data, this.error);

  static DomainResponse<T?> fromJson<T>(Map<String, dynamic> json) {
    return _$DomainResponseFromJson(json, _responseTypedBodyFromJson);
  }

  static DomainResponse<T?> fromJsonStr<T>(String jsonStr) {
    final Map<String, dynamic> json = jsonDecode(jsonStr) as Map<String, dynamic>;
    return DomainResponse.fromJson(json);
  }

  static T? _responseTypedBodyFromJson<T>(Object? json) {
    if (json == null) {
      return null;
    }

    if (json is! Map<String, dynamic>) {
      throw ArgumentError.value('Invalid type. Map<String, dynamic> needed', 'jsonObj');
    }

    return CelebSimilarityResponseBody.fromJson(json) as T?;
  }

  @JsonKey(name: 'data')
  final T? data;

  @JsonKey(name: 'error')
  final ApiError? error;
}

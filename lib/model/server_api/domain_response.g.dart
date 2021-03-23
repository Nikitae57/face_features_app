// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DomainResponse<T> _$DomainResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) {
  return $checkedNew('DomainResponse', json, () {
    final val = DomainResponse<T>(
      $checkedConvert(
          json, 'data', (v) => _$nullableGenericFromJson(v, fromJsonT)),
      $checkedConvert(
          json,
          'error',
          (v) =>
              v == null ? null : ApiError.fromJson(v as Map<String, dynamic>)),
    );
    return val;
  });
}

Map<String, dynamic> _$DomainResponseToJson<T>(
  DomainResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'error': instance.error,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

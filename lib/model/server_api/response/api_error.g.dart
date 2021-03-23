// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiError _$ApiErrorFromJson(Map<String, dynamic> json) {
  return $checkedNew('ApiError', json, () {
    final val = ApiError(
      $checkedConvert(json, 'type', (v) => v as int),
      $checkedConvert(json, 'message', (v) => v as String),
    );
    return val;
  });
}

Map<String, dynamic> _$ApiErrorToJson(ApiError instance) => <String, dynamic>{
      'type': instance.type,
      'message': instance.message,
    };

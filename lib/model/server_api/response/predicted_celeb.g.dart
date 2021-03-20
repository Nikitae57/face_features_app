// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predicted_celeb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PredictedCeleb _$PredictedCelebFromJson(Map<String, dynamic> json) {
  return $checkedNew('PredictedCeleb', json, () {
    final val = PredictedCeleb(
      name: $checkedConvert(json, 'name', (v) => v as String),
      probability:
          $checkedConvert(json, 'probability', (v) => (v as num).toDouble()),
    );
    return val;
  });
}

Map<String, dynamic> _$PredictedCelebToJson(PredictedCeleb instance) =>
    <String, dynamic>{
      'name': instance.name,
      'probability': instance.probability,
    };

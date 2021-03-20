// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prediction _$PredictionFromJson(Map<String, dynamic> json) {
  return $checkedNew('Prediction', json, () {
    final val = Prediction(
      mostSimilarFaceUrl:
          $checkedConvert(json, 'most_similar_face_url', (v) => v as String),
      predictedCelebs: $checkedConvert(
          json,
          'predicted_celebs',
          (v) => (v as List<dynamic>)
              .map((e) => PredictedCeleb.fromJson(e as Map<String, dynamic>))
              .toList()),
    );
    return val;
  }, fieldKeyMap: const {
    'mostSimilarFaceUrl': 'most_similar_face_url',
    'predictedCelebs': 'predicted_celebs'
  });
}

Map<String, dynamic> _$PredictionToJson(Prediction instance) =>
    <String, dynamic>{
      'most_similar_face_url': instance.mostSimilarFaceUrl,
      'predicted_celebs': instance.predictedCelebs,
    };

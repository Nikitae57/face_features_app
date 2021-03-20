// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'celeb_similarity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CelebSimilarityResult _$CelebSimilarityResponseFromJson(
    Map<String, dynamic> json) {
  return $checkedNew('CelebSimilarityResponse', json, () {
    final val = CelebSimilarityResult(
      userCroppedFaceImgId:
          $checkedConvert(json, 'user_cropped_face_id', (v) => v as String),
      predictions: $checkedConvert(
          json,
          'predictions',
          (v) => (v as List<dynamic>)
              .map((e) => Prediction.fromJson(e as Map<String, dynamic>))
              .toList()),
    );
    return val;
  }, fieldKeyMap: const {'userCroppedFaceImgId': 'user_cropped_face_id'});
}

Map<String, dynamic> _$CelebSimilarityResponseToJson(
        CelebSimilarityResult instance) =>
    <String, dynamic>{
      'user_cropped_face_id': instance.userCroppedFaceImgId,
      'predictions': instance.predictions,
    };

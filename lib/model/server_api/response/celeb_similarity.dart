import 'dart:convert';

import 'package:face_features/model/server_api/response/prediction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'celeb_similarity.g.dart';

@JsonSerializable()
class CelebSimilarityResult {
  CelebSimilarityResult({required this.userCroppedFaceImgId, required this.predictions});

  factory CelebSimilarityResult.fromJson(Map<String, dynamic> json) =>
      _$CelebSimilarityResponseFromJson(json);

  factory CelebSimilarityResult.fromJsonStr(String jsonStr) {
    final Map<String, dynamic> json = jsonDecode(jsonStr) as Map<String, dynamic>;
    return CelebSimilarityResult.fromJson(json);
  }

  Map<String, dynamic> toJson() => _$CelebSimilarityResponseToJson(this);

  @JsonKey(name: 'user_cropped_face_id')
  final String userCroppedFaceImgId;

  @JsonKey(name: 'predictions')
  final List<Prediction> predictions;
}

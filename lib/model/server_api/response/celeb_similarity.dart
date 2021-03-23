import 'dart:convert';

import 'package:face_features/model/server_api/response/prediction.dart';
import 'package:face_features/model/server_api/response/response_body.dart';
import 'package:json_annotation/json_annotation.dart';

part 'celeb_similarity.g.dart';

@JsonSerializable()
class CelebSimilarityResponseBody implements IResponseBody {
  CelebSimilarityResponseBody({required this.userCroppedFaceImgId, required this.predictions});

  factory CelebSimilarityResponseBody.fromJson(Map<String, dynamic> json) =>
      _$CelebSimilarityResponseBodyFromJson(json);

  factory CelebSimilarityResponseBody.fromJsonStr(String jsonStr) {
    final Map<String, dynamic> json = jsonDecode(jsonStr) as Map<String, dynamic>;
    return CelebSimilarityResponseBody.fromJson(json);
  }

  Map<String, dynamic> toJson() => _$CelebSimilarityResponseBodyToJson(this);

  @JsonKey(name: 'user_cropped_face_id')
  final String userCroppedFaceImgId;

  @JsonKey(name: 'predictions')
  final List<Prediction> predictions;
}

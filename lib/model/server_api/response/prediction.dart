import 'package:face_features/model/server_api/response/predicted_celeb.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prediction.g.dart';

@JsonSerializable()
class Prediction {
  Prediction({required this.mostSimilarFaceUrl, required this.predictedCelebs});

  factory Prediction.fromJson(Map<String, dynamic> json) => _$PredictionFromJson(json);

  Map<String, dynamic> toJson() => _$PredictionToJson(this);

  @JsonKey(name: 'most_similar_face_url')
  final String mostSimilarFaceUrl;

  @JsonKey(name: 'predicted_celebs')
  List<PredictedCeleb> predictedCelebs;
}
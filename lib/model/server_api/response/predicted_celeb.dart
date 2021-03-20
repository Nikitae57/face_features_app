import 'package:json_annotation/json_annotation.dart';

part 'predicted_celeb.g.dart';

@JsonSerializable()
class PredictedCeleb {
  PredictedCeleb({required this.name, required this.probability});

  factory PredictedCeleb.fromJson(Map<String, dynamic> json) =>
      _$PredictedCelebFromJson(json);

  Map<String, dynamic> toJson() => _$PredictedCelebToJson(this);

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'probability')
  final double probability;
}
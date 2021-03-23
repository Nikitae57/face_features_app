import 'dart:convert';
import 'dart:io';

import 'package:face_features/model/server_api/domain_response.dart';
import 'package:face_features/model/server_api/error/codes.dart';
import 'package:face_features/model/server_api/response/celeb_similarity.dart';
import 'package:face_features/model/server_api/response/prediction.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  final String testJsonStr = File('test_resources/json/domain_response_celeb_similarity.json')
      .readAsStringSync();
  final String jsonWithErrorStr = File('test_resources/json/domain_response_celeb_similarity_error.json')
      .readAsStringSync();

  final Map<String, dynamic> testJson = jsonDecode(testJsonStr) as Map<String, dynamic>;
  final Map<String, dynamic> jsonWithError = jsonDecode(jsonWithErrorStr) as Map<String, dynamic>;

  test('Convert JSON to DomainResponse<CelebSimilarityResponseBody>', () async {
    final DomainResponse<CelebSimilarityResponseBody?> response = DomainResponse.fromJson(testJson);

    assert(response.error == null);
    assert(response.data != null);

    final CelebSimilarityResponseBody celeb = response.data!;
    assert(celeb.userCroppedFaceImgId == 'bfb0b31da25f4085b020');
    assert(celeb.predictions.length == 1);

    final Prediction pred = celeb.predictions[0];

    assert(pred.mostSimilarFaceUrl == 'static/img/celeb/optimized_vgg/Wesley Jonathan/80e835ea1e.jpg');
    assert(pred.predictedCelebs.length == 3);

    assert(pred.predictedCelebs[0].name == 'Wesley Jonathan');
    assert(pred.predictedCelebs[1].name == 'Billy Dee Williams');
    assert(pred.predictedCelebs[2].name == 'CCH Pounder');

    assert((pred.predictedCelebs[0].probability - 0.9973406195640564).abs() < 0.001);
    assert((pred.predictedCelebs[1].probability - 0.0004724319151137024).abs() < 0.001);
    assert((pred.predictedCelebs[2].probability - 0.00024880768614821136).abs() < 0.001);
  });

  test('Convert JSON with error to DomainResponse<CelebSimilarityResponseBody>', () async {
    final DomainResponse<CelebSimilarityResponseBody?> response = DomainResponse.fromJson(jsonWithError);

    assert(response.error != null);
    assert(response.data == null);

    final ServerErrors error = errorCodeToDomain(response.error!.type);
    assert(error == ServerErrors.MoreThanOneFace);
  });
}
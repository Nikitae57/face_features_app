import 'dart:convert';
import 'dart:io';

import 'package:face_features/model/server_api/response/celeb_similarity.dart';
import 'package:face_features/model/server_api/response/prediction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final String testJsonStr = File('test_resources/json/celeb_similarity.json').readAsStringSync();
  final Map<String, dynamic> testJson = jsonDecode(testJsonStr) as Map<String, dynamic>;

  test('Convert JSON to CelebSimilarityResponseBody instance', () {
    final CelebSimilarityResponseBody celeb = CelebSimilarityResponseBody.fromJson(testJson);
    assert(celeb.userCroppedFaceImgId == 'd944a72205ab48e19883');
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
}
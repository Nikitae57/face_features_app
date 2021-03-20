import 'dart:io';

import 'package:face_features/config.dart';
import 'package:face_features/model/server_api/response/celeb_similarity.dart';
import 'package:face_features/model/server_api/server_api.dart';
import 'package:face_features/model/server_api/util.dart';
import 'package:flutter_test/flutter_test.dart';


const String WESLEY_JONATHAN_IMG_PATH = 'test_resources/80e835ea1e.jpg'; // Wesley Jonathan
const String WESLEY_JONATHAN_NAME = 'Wesley Jonathan';

const String CACHE_DIR = 'test_resources/cache';


void _deleteCacheDir() {
  final Directory cacheDir = Directory(CACHE_DIR);
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
}

void _createCacheDir() {
  final Directory cacheDir = Directory(CACHE_DIR);
  cacheDir.createSync();
}

void main() {
  final ServerApi api = ServerApi(baseUrl: serverBaseUrl, cacheDir: CACHE_DIR);

  group('Test server celeb similarity API', () {
    setUpAll(() {
      _deleteCacheDir();
      _createCacheDir();
    });

    tearDownAll(_deleteCacheDir);

    test('Get filename from content disposition', () {
      const List<String> contentDisposition = <String>[
        'attachment; filename=content.txt',
        'attachment; filename=filename.txt',
        'attachment; filename="omÃ¡Ã¨ka.jpg"',
      ];

      const List<String> fileNames = <String>[
        'content.txt',
        'filename.txt',
        'omÃ¡Ã¨ka.jpg'
      ];

      for (int i = 0; i < contentDisposition.length; i++) {
        final String? fileName = getFileNameFromContentDisposition(contentDisposition[i]);
        assert(fileName != null);

        assert(fileName! == fileNames[i]);
      }
    });

    test('Test server celeb similarity predictions', () async {
      final CelebSimilarityResult response = await api.getCelebSimilarity(WESLEY_JONATHAN_IMG_PATH);

      assert(response.predictions.isNotEmpty);
      assert(response.predictions[0].predictedCelebs.isNotEmpty);
      assert(response.predictions[0].predictedCelebs[0].name == WESLEY_JONATHAN_NAME);
    });

    test('Test get cropped user image API', () async {
      final CelebSimilarityResult response = await api.getCelebSimilarity(WESLEY_JONATHAN_IMG_PATH);
      await api.getUserCroppedImage(response.userCroppedFaceImgId);
    });
  });
}
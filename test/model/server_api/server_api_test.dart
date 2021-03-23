import 'dart:io';

import 'package:face_features/config.dart';
import 'package:face_features/model/server_api/domain_response.dart';
import 'package:face_features/model/server_api/error/codes.dart';
import 'package:face_features/model/server_api/response/celeb_similarity.dart';
import 'package:face_features/model/server_api/server_api.dart';
import 'package:face_features/model/server_api/util.dart';
import 'package:flutter_test/flutter_test.dart';


const String WESLEY_JONATHAN_IMG_PATH = 'test_resources/img/80e835ea1e.jpg';
const String MULTIPLE_FACES_IMG_PATH = 'test_resources/img/fbe73484a9.jpg';
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

    test('Test server celeb similarity ok predictions', () async {
      final DomainResponse<CelebSimilarityResponseBody?> response =
        await api.getCelebSimilarity(WESLEY_JONATHAN_IMG_PATH);

      assert(response.error == null);
      assert(response.data != null);

      final CelebSimilarityResponseBody celebSimilarity = response.data!;
      assert(celebSimilarity.predictions.isNotEmpty);
      assert(celebSimilarity.predictions[0].predictedCelebs.isNotEmpty);
      assert(celebSimilarity.predictions[0].predictedCelebs[0].name == WESLEY_JONATHAN_NAME);
    });

    test('Test server multiple faces error', () async {
      final DomainResponse<CelebSimilarityResponseBody?> response =
      await api.getCelebSimilarity(MULTIPLE_FACES_IMG_PATH);

      assert(response.error != null);
      assert(response.data == null);

      final ServerErrors error = errorCodeToDomain(response.error!.type);
      assert(error == ServerErrors.MoreThanOneFace);
    });

    test('Test get cropped user image API', () async {
      final DomainResponse<CelebSimilarityResponseBody?> response =
        await api.getCelebSimilarity(WESLEY_JONATHAN_IMG_PATH);

      assert(response.data != null);
      assert(response.error == null);

      final String savePath = await api.getUserCroppedImage(response.data!.userCroppedFaceImgId);
      final File imgFile = File(savePath);

      assert(imgFile.existsSync());
      assert(imgFile.lengthSync() > 0);
    });
  });
}
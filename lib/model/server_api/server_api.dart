
import 'package:dio/dio.dart';
import 'package:face_features/model/server_api/response/celeb_similarity.dart';
import 'package:face_features/model/server_api/util.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';


CelebSimilarityResult _celebSimilarityResponseFromJsonStr(String json) {
  return CelebSimilarityResult.fromJsonStr(json);
}


class ServerApi {
  ServerApi({required String baseUrl, required String cacheDir})
      : _cacheDir = cacheDir,
        _dio = Dio(BaseOptions(baseUrl: baseUrl));

  static const String CELEB_SIMILARITY_ROUTE = '/api/v1/predict';
  static const String GET_CROPPED_USER_IMG_ROUTE = '/api/v1/cropped-face/{face_uuid}';
  static const String FACE_UUID_TEMPLATE = '{face_uuid}';

  final Dio _dio;
  final String _cacheDir;

  Future<CelebSimilarityResult> getCelebSimilarity(String imgPath) async {
    final FormData formData = FormData.fromMap(<String, dynamic>{
      'image': await MultipartFile.fromFile(imgPath, contentType: MediaType('image', '*')),
    });

    final Response<String> response = await _dio.post<String>(CELEB_SIMILARITY_ROUTE, data: formData);

    if (response.statusCode != 200 || response.data == null) {
      throw Exception();
    }

    final Future<CelebSimilarityResult> celebSimilarityResponse =
        compute<String, CelebSimilarityResult>(_celebSimilarityResponseFromJsonStr, response.data!);

    return celebSimilarityResponse;
  }

  Future<String> getUserCroppedImage(String imgId) async {
    final String route = GET_CROPPED_USER_IMG_ROUTE.replaceFirst(FACE_UUID_TEMPLATE, imgId);
    await _dio.download(route, (Headers headers) {
      final String contentDisposition = headers.value('content-disposition')!;
      final String? fileName = getFileNameFromContentDisposition(contentDisposition);
      final String savePath = join(_cacheDir, fileName!);

      return savePath;
    });

    return Future<String>(() => '');
  }

  // Future<void> save
}

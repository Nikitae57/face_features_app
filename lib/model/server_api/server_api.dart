
import 'package:dio/dio.dart';
import 'package:face_features/model/server_api/domain_response.dart';
import 'package:face_features/model/server_api/response/celeb_similarity.dart';
import 'package:face_features/model/server_api/util.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';


DomainResponse<CelebSimilarityResponseBody?> _celebSimilarityResponseFromJsonStr(String json) {
  return DomainResponse.fromJsonStr(json);
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

  Future<DomainResponse<CelebSimilarityResponseBody?>> getCelebSimilarity(String imgPath) async {
    final FormData formData = FormData.fromMap(<String, dynamic>{
      'image': await MultipartFile.fromFile(imgPath, contentType: MediaType('image', '*')),
    });

    final Response<String> response = await _dio.post<String>(CELEB_SIMILARITY_ROUTE, data: formData);

    if (response.statusCode != 200 || response.data == null) {
      throw Exception();
    }

    final Future<DomainResponse<CelebSimilarityResponseBody?>> responseBody =
      compute<String, DomainResponse<CelebSimilarityResponseBody?>>(
          _celebSimilarityResponseFromJsonStr, response.data!
      );

    return responseBody;
  }

  Future<String> getUserCroppedImage(String imgId) {
    final String url = GET_CROPPED_USER_IMG_ROUTE.replaceFirst(FACE_UUID_TEMPLATE, imgId);
    return _downloadImage(url);
  }

  Future<String> getCelebImage(String url) => _downloadImage(url);

  String _getTmpSavePath(Headers headers) {
    final String contentDisposition = headers.value('content-disposition')!;
    final String? fileName = getFileNameFromContentDisposition(contentDisposition);
    final String savePath = join(_cacheDir, fileName!);

    return savePath;
  }
  
  Future<String> _downloadImage(String url) async {
    String savePath = '';
    await _dio.download(url, (Headers headers) {
      savePath = _getTmpSavePath(headers);
      return savePath;
    });

    return Future<String>(() => savePath);
  }
}

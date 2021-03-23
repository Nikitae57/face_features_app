import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:face_features/config.dart' as config;
import 'package:face_features/model/celeb_similarity_result.dart';
import 'package:face_features/model/image_processing/compression/compression_params.dart';
import 'package:face_features/model/image_processing/compression/compressor.dart';
import 'package:face_features/model/server_api/domain_response.dart';
import 'package:face_features/model/server_api/error/codes.dart';
import 'package:face_features/model/server_api/error/exception.dart';
import 'package:face_features/model/server_api/response/api_error.dart';
import 'package:face_features/model/server_api/response/celeb_similarity.dart';
import 'package:face_features/model/server_api/response/predicted_celeb.dart';
import 'package:face_features/model/server_api/response/prediction.dart';
import 'package:face_features/model/server_api/server_api.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'image_processing_event.dart';
part 'image_processing_state.dart';

class ImageProcessingBloc extends Bloc<ImageProcessingEvent, ImageProcessingState> {
  ImageProcessingBloc._(this._serverApi) : super(InitialImageProcessingState());

  static ImageProcessingBloc create() {
    final Future<ServerApi> serverApi = _initServerApi();
    return ImageProcessingBloc._(serverApi);
  }
  
  late final Future<ServerApi> _serverApi;

  static Future<ServerApi> _initServerApi() async {
    final Directory cacheDir = await getTemporaryDirectory();
    return ServerApi(baseUrl: config.serverBaseUrl, cacheDir: cacheDir.path);
  }

  @override
  Stream<ImageProcessingState> mapEventToState(ImageProcessingEvent event) async* {
    if (event is ProcessImageEvent) {
      yield* _mapProcessImageEventToState(event);
    } else {
      throw ArgumentError('Unknown event: $event');
    }
  }

  Stream<ImageProcessingState> _mapProcessImageEventToState(ProcessImageEvent event) async* {
    try {
      yield CompressingImageState(event.imagePath);
      final String compressedImagePath = await _compressImage(event.imagePath);

      yield GettingImageProcessingResultState(event.imagePath);
      final DomainResponse<CelebSimilarityResponseBody?> response = await _getCelebSimilarity(compressedImagePath);

      if (response.error != null) {
        yield _mapApiErrorToState(response.error!);
        return;
      }

      if (response.data == null || response.data!.predictions.isEmpty) {
        yield ImageProcessingEmptyResultState();
        return;
      }

      final CelebSimilarityResponseBody celebSimilarity = response.data!;

      final Future<String> userCroppedImgPath = _fetchUserCroppedImage(celebSimilarity.userCroppedFaceImgId);
      final PredictedCeleb mostSimilarCeleb = _getMostSimilarCeleb(celebSimilarity.predictions);
      final Future<String> celebFaceImgPath = _fetchCelebImage(celebSimilarity.predictions[0].mostSimilarFaceUrl);

      final CelebSimilarityResult result = CelebSimilarityResult(
          await userCroppedImgPath, await celebFaceImgPath, mostSimilarCeleb.name
      );

      yield GotImageProcessingResult<CelebSimilarityResult>(result);
    } on NetworkException {
      yield ImageProcessingNetworkErrorState();
    } on Exception catch (e) {
      print(e);
      yield ImageProcessingInternalErrorState();
    }
  }
  
  PredictedCeleb _getMostSimilarCeleb(Iterable<Prediction> predictions) {
    if (predictions.isEmpty) {
      throw ArgumentError('Predictions iterable is empty');
    }
    
    return predictions.first.predictedCelebs.first;
  }

  ImageProcessingState _mapApiErrorToState(ApiError error) {
    final ServerErrors errorType = errorCodeToDomain(error.type);
    switch(errorType) {
      case ServerErrors.MoreThanOneFace:
        return ImageProcessingMoreThanOneFaceErrorState();
      default:
        return ImageProcessingInternalErrorState();
    }
  }

  Future<String> _getCompressedImageTargetPath() async {
    final Directory cacheDir = await getTemporaryDirectory();
    final String uuid = const Uuid().v1();
    final String targetPath = p.join(cacheDir.path, '$uuid.jpg');

    return targetPath;
  }

  Future<CompressionParams> _getCompressionParams(String sourceImagePath) async {
    final String targetPath = await _getCompressedImageTargetPath();
    const int quality = 85;
    final CompressionParams params = CompressionParams(sourceImagePath, targetPath, quality);
    
    return params;
  }
  
  Future<String> _compressImage(String imagePath) async {
    final CompressionParams params = await _getCompressionParams(imagePath);
    await Compressor.compressImageFile(params);
    // await compute<CompressionParams, void>(Compressor.compressImageFile, params);
    
    return params.targetPath;
  }
  
  Future<DomainResponse<CelebSimilarityResponseBody?>> _getCelebSimilarity(String imagePath) async {
    final ServerApi serverApi = await _serverApi;
    return serverApi.getCelebSimilarity(imagePath);
  }

  Future<String> _fetchUserCroppedImage(String imgId) async {
    final ServerApi serverApi = await _serverApi;
    return serverApi.getUserCroppedImage(imgId);
  }

  Future<String> _fetchCelebImage(String url) async {
    final ServerApi serverApi = await _serverApi;
    return serverApi.getCelebImage(url);
  }
}

part of 'image_processing_bloc.dart';

@immutable
abstract class ImageProcessingState {}

class InitialImageProcessingState extends ImageProcessingState {}

class CompressingImageState extends ImageProcessingState {
  CompressingImageState(this.imagePath);
  final String imagePath;
}

class GettingImageProcessingResultState extends ImageProcessingState {
  GettingImageProcessingResultState(this.imagePath);
  final String imagePath;
}

class GotImageProcessingResult<T> extends ImageProcessingState {
  GotImageProcessingResult(this.result);
  final T result;
}

class ImageProcessingNetworkErrorState extends ImageProcessingState {}

class ImageProcessingInternalErrorState extends ImageProcessingState {}

class ImageProcessingMoreThanOneFaceErrorState extends ImageProcessingState {}

class ImageProcessingEmptyResultState extends ImageProcessingState {}

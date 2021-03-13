part of 'image_choice_bloc.dart';

@immutable
abstract class ImageChoiceState {}

class ImageChoiceInitialState extends ImageChoiceState {}

class ImageChoiceCameraState extends ImageChoiceState {}

class ImageChoiceGalleryState extends ImageChoiceState {}

class ImageChoiceErrorState extends ImageChoiceState {
  ImageChoiceErrorState(this.message);
  final String message;
}

@immutable
class ImageChoiceGotFileState extends ImageChoiceState {
  ImageChoiceGotFileState(this.image);
  final UserImage image;
}
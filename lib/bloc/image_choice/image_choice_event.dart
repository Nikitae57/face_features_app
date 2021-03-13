part of 'image_choice_bloc.dart';

@immutable
abstract class ImageChoiceEvent {}

class ImageChoiceTakePhotoEvent extends ImageChoiceEvent {}

class ImageChoicePickPhotoFromGalleryEvent extends ImageChoiceEvent {}

class ImageChoicePickerReturnedEvent extends ImageChoiceEvent {
  ImageChoicePickerReturnedEvent(PickedFile? pickedFile)
      : image = pickedFile == null ? null : UserImage(pickedFile.path);
  final UserImage? image;
}

class ImageChoiceRestoredLostDataEvent extends ImageChoiceEvent {
  ImageChoiceRestoredLostDataEvent(this.lostImage);
  final UserImage lostImage;
}

class ImageChoiceResetEvent extends ImageChoiceEvent {}
part of 'image_choice_bloc.dart';

@immutable
abstract class ImageChoiceEvent {}

class ImageChoiceTakePhotoEvent extends ImageChoiceEvent {}

class ImageChoicePickPhotoFromGalleryEvent extends ImageChoiceEvent {}

class ImageChoicePickerReturned extends ImageChoiceEvent {
  ImageChoicePickerReturned(this.pickedFile);
  final PickedFile pickedFile;
}

class ImageChoiceRestoredLostDataEvent extends ImageChoiceEvent {
  ImageChoiceRestoredLostDataEvent(this.lostData);
  final LostData lostData;
}

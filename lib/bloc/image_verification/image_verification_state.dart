part of 'image_verification_bloc.dart';


@immutable
abstract class ImageVerificationState {}

class ImageVerificationInitialState extends ImageVerificationState {
  ImageVerificationInitialState(this.image);
  final UserImage image;
}

class ImageVerifiedState extends ImageVerificationState {
  ImageVerifiedState(this.image);
  final UserImage image;
}

class ImageDeniedState extends ImageVerificationState {}
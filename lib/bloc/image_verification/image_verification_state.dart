part of 'image_verification_bloc.dart';


@immutable
abstract class ImageVerificationState {}

class ImageVerificationInitial extends ImageVerificationState {
  ImageVerificationInitial(this.image);
  final UserImage image;
}

class ImageVerifiedState extends ImageVerificationState {
  ImageVerifiedState(this.image);
  final UserImage image;
}

class ImageDeniedState extends ImageVerificationState {}
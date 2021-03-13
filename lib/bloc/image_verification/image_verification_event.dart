part of 'image_verification_bloc.dart';

@immutable
abstract class ImageVerificationEvent {}

class ImageVerifiedEvent extends ImageVerificationEvent {}

class ImageDeniedEvent extends ImageVerificationEvent {}

part of 'image_verification_bloc.dart';

@immutable
abstract class ImageVerificationEvent {}

class ImageVerificationIdlingEvent extends ImageVerificationEvent {}

class ImageVerificationAcceptedEvent extends ImageVerificationEvent {}

class ImageDeniedEvent extends ImageVerificationEvent {}

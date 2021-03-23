part of 'image_processing_bloc.dart';

@immutable
abstract class ImageProcessingEvent {}

class ProcessImageEvent extends ImageProcessingEvent {
  ProcessImageEvent(this.imagePath);
  final String imagePath;
}

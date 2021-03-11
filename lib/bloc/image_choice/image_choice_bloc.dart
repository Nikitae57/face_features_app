import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'image_choice_event.dart';
part 'image_choice_state.dart';

class ImageChoiceBloc extends Bloc<ImageChoiceEvent, ImageChoiceState> {
  ImageChoiceBloc() : super(InitialImageChoiceState()) {
    _checkForLostData();
  }
  final ImagePicker _picker = ImagePicker();

  @override
  Stream<ImageChoiceState> mapEventToState(ImageChoiceEvent event) async* {
    if (event is ImageChoiceTakePhotoEvent) {
      yield* _mapTakePhotoToState();
    } else if (event is ImageChoicePickPhotoFromGalleryEvent) {
      yield* _mapPickPhotoFromGalleryToState();
    } else if (event is ImageChoiceRestoredLostDataEvent) {
      yield ImageChoiceGotFileState(event.lostData.file);
    } else if (event is ImageChoicePickerReturned) {
      yield* _mapPickerReturnedToState(event.pickedFile);
    }
    
    else {
      yield ImageChoiceErrorState('Unknown event: ${event.runtimeType}');
    }
  }

  Stream<ImageChoiceState> _mapPickerReturnedToState(PickedFile pickedFile) async* {
    if (pickedFile == null) {
      yield ImageChoiceErrorState('Failed to pick a file');
    } else {
      yield ImageChoiceGotFileState(pickedFile);
    }
  }

  Stream<ImageChoiceState> _mapTakePhotoToState() async* {
    yield ImageChoiceCameraState();
  }

  Stream<ImageChoiceState> _mapPickPhotoFromGalleryToState() async* {
    yield ImageChoiceGalleryState();
  }

  // If MainActivity was destroyed while user was picking a photo
  Future<void> _checkForLostData() async {
    if (Platform.isAndroid) {
      final LostData lostData = await _picker.getLostData();

      if (!lostData.isEmpty && lostData.file != null) {
        add(ImageChoiceRestoredLostDataEvent(lostData));
      }
    }
  }
}

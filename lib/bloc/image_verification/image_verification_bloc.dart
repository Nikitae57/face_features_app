import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:face_features/model/user_photo.dart';
import 'package:meta/meta.dart';

part 'image_verification_event.dart';
part 'image_verification_state.dart';

class ImageVerificationBloc extends Bloc<ImageVerificationEvent, ImageVerificationState> {
  ImageVerificationBloc(this._image) : super(ImageVerificationInitialState(_image));

  final UserImage _image;

  @override
  Stream<ImageVerificationState> mapEventToState(ImageVerificationEvent event) async* {
    if (event is ImageVerifiedEvent) {
      yield ImageVerifiedState(_image);
    } else if (event is ImageDeniedEvent) {
      yield ImageDeniedState();
    } else {
      throw Exception('Unknown event ${state.runtimeType}');
    }
  }
}

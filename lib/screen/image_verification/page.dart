import 'package:face_features/bloc/image_verification/image_verification_bloc.dart';
import 'package:face_features/model/user_photo.dart';
import 'package:face_features/screen/image_verification/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageVerificationPage extends StatelessWidget {
  const ImageVerificationPage({Key? key, required UserImage image})
      : _image = image,
        super(key: key);

  final UserImage _image;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImageVerificationBloc>(
      create: (_) => ImageVerificationBloc(_image),
      child: ImageVerificationView(image: _image),
    );
  }
}

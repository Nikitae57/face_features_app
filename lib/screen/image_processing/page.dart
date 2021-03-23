import 'package:face_features/bloc/image_processing/image_processing_bloc.dart';
import 'package:face_features/model/user_photo.dart';
import 'package:face_features/screen/image_processing/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageProcessingPage extends StatelessWidget {
  const ImageProcessingPage({Key? key, required UserImage image})
      : _image = image,
        super(key: key);

  final UserImage _image;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImageProcessingBloc>(
      create: (_) => ImageProcessingBloc.create()..add(ProcessImageEvent(_image.path)),
      child: const ImageProcessingView(),
    );
  }
}

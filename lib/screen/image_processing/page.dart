import 'package:face_features/bloc/image_processing/image_processing_bloc.dart';
import 'package:face_features/screen/image_processing/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageProcessingPage extends StatelessWidget {
  const ImageProcessingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return BlocProvider<ImageProcessingBloc>(
      create: (_) => ImageProcessingBloc.create(),
      child: const ImageProcessingView(),
    );
  }
}

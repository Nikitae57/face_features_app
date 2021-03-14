import 'package:face_features/bloc/image_choice/image_choice_bloc.dart';
import 'package:face_features/screen/image_choice/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageChoicePage extends StatelessWidget {
  const ImageChoicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImageChoiceBloc>(
      create: (_) => ImageChoiceBloc(),
      child: const ImageChoiceView(),
    );
  }
}

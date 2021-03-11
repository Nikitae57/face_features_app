import 'package:face_features/bloc/image_choice/image_choice_bloc.dart';
import 'package:face_features/screen/image_choice/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageChoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImageChoiceBloc(),
      child: ImageChoiceView(),
    );
  }
}

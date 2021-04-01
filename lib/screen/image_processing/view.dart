import 'package:face_features/bloc/image_processing/image_processing_bloc.dart';
import 'package:face_features/screen/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../route_generator.dart';

class ImageProcessingView extends StatefulWidget {
  const ImageProcessingView({Key? key}) : super(key: key);

  @override
  _ImageProcessingViewState createState() => _ImageProcessingViewState();
}

class _ImageProcessingViewState extends State<ImageProcessingView> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ImageProcessingBloc, ImageProcessingState>(
        listener: (BuildContext context, ImageProcessingState state) => _listenState(context, state),
        child: Container(
          height: double.infinity,
          decoration: getBackgroundGradient(context),
          child: BlocBuilder<ImageProcessingBloc, ImageProcessingState>(
            bloc: BlocProvider.of<ImageProcessingBloc>(context),
            builder: (BuildContext context, ImageProcessingState state) => _buildState(context, state),
          ),
        ),
      ),
    );
  }

  Widget _buildState(BuildContext context, ImageProcessingState state) {
    return const SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: CircularProgressIndicator.adaptive(),
    );
  }

  void _listenState(BuildContext context, ImageProcessingState state) {
    if (state is ImageProcessingNetworkErrorState) {
      _showNetworkError(context);
      _navigateToImageChoice(context);
    } else if (state is ImageProcessingInternalErrorState) {
      _showInternalError(context);
      _navigateToImageChoice(context);
    }
  }

  Future<void> _navigateToImageChoice(BuildContext context) async {
    await RouteGenerator.navigateToImageChoice(context: context, clearStack: true);
  }

  void _showNetworkError(BuildContext context) {
    const String message = 'Network error occurred';
    _showSnackBar(context, message);
  }

  void _showInternalError(BuildContext context) {
    const String message = 'Something went wrong. Try again later';
    _showSnackBar(context, message);
  }

  void _showSnackBar(BuildContext context, String text) {
    final SnackBar snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

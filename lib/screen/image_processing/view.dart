import 'package:face_features/bloc/image_processing/image_processing_bloc.dart';
import 'package:face_features/model/celeb_similarity_result.dart';
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
        child: BlocBuilder<ImageProcessingBloc, ImageProcessingState>(
          bloc: BlocProvider.of<ImageProcessingBloc>(context),
          builder: (BuildContext context, ImageProcessingState state) => _view(context, state),
        ),
      ),
    );
  }

  Widget _view(BuildContext context, ImageProcessingState state) {
    return WillPopScope(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: getBackgroundGradient(context),
        child: _buildState(context, state),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  Widget _buildState(BuildContext context, ImageProcessingState state) {
    return const SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  void _listenState(BuildContext context, ImageProcessingState state) {
    if (state is ImageProcessingNetworkErrorState) {
      _processNetworkError(context);
    } else if (state is ImageProcessingInternalErrorState) {
      _processInternalError(context);
    } else if (state is ImageProcessingMoreThanOneFaceErrorState) {
      _processMoreThanOneFaceError(context);
    } else if (state is ImageProcessingNoFacesErrorState) {
      _processNoFacesError(context);
    } else if (state is GotImageProcessingResult<CelebSimilarityResult>) {
      RouteGenerator.navigateToImgProcessingResult(context: context, result: state.result);
    }
  }

  Future<void> _navigateToImageChoice(BuildContext context) async {
    await RouteGenerator.navigateToImageChoice(context: context, clearStack: true);
  }

  void _processNetworkError(BuildContext context) {
    _showNetworkError(context);
    _navigateToImageChoice(context);
  }

  void _processInternalError(BuildContext context) {
    _showInternalError(context);
    _navigateToImageChoice(context);
  }

  void _processMoreThanOneFaceError(BuildContext context) {
    _showMoreThanOneFaceError(context);
    _navigateToImageChoice(context);
  }

  void _processNoFacesError(BuildContext context) {
    _showNoFacesError(context);
    _navigateToImageChoice(context);
  }

  void _showNetworkError(BuildContext context) {
    const String message = 'Network error occurred';
    _showSnackBar(context, message);
  }

  void _showNoFacesError(BuildContext context) {
    const String message = 'No faces found on image';
    _showSnackBar(context, message);
  }

  void _showMoreThanOneFaceError(BuildContext context) {
    const String message = 'Found more than one face';
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

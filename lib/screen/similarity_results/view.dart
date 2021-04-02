import 'dart:io';

import 'package:face_features/bloc/similarity_results/similarity_results_bloc.dart';
import 'package:face_features/model/celeb_similarity_result.dart';
import 'package:face_features/route_generator.dart';
import 'package:face_features/screen/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimilarityResultsView extends StatefulWidget {
  const SimilarityResultsView({Key? key}) : super(key: key);

  @override
  _SimilarityResultsState createState() => _SimilarityResultsState();
}

class _SimilarityResultsState extends State<SimilarityResultsView> with TickerProviderStateMixin {
  double _celebImageAlpha = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SimilarityResultsBloc, SimilarityResultsState>(
        listener: (BuildContext context, SimilarityResultsState state) => _listenState(context, state),
        child: BlocBuilder<SimilarityResultsBloc, SimilarityResultsState>(
          builder: (BuildContext context, SimilarityResultsState state) {
            return _view(context, state);
          },
        ),
      ),
    );
  }

  void _listenState(BuildContext context, SimilarityResultsState state) {
    if (state is SimilarityResultsUploadingNewImageState) {
      RouteGenerator.navigateToImageChoice(context: context, clearStack: true);
    }
  }

  Widget _view(BuildContext context, SimilarityResultsState state) {
    return WillPopScope(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: getBackgroundGradient(context),
        child: _buildState(context, state),
      ),
      onWillPop: () async {
        RouteGenerator.navigateToImageChoice(context: context, clearStack: true);
        return true;
      },
    );
  }

  Widget _buildState(BuildContext context, SimilarityResultsState state) {
    if (state is InitialSimilarityResultsState) {
      return _gotSimilarityResults(context, state.similarity);
    } else {
      return const SizedBox();
    }
  }

  Widget _gotSimilarityResults(BuildContext context, CelebSimilarityResult result) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Spacer(),
        Text(
          result.celebName,
          style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w300),
        ),
        Stack(
          children: <Widget>[
            Image.file(File(result.userImagePath)),
            Opacity(
              opacity: _celebImageAlpha,
              child: Image.file(File(result.celebImagePath)),
            ),
          ],
        ),
        Slider.adaptive(
          value: _celebImageAlpha,
          onChanged: (double value) {
            setState(() {
              _celebImageAlpha = value;
            });
          },
          min: 0.0,
          max: 1.0,
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.replay),
              label: const Text(
                'Upload another image',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                final SimilarityResultsBloc bloc = context.read<SimilarityResultsBloc>();
                bloc.add(SimilarityResultsUploadNewImageEvent());
              },
            ),
          ),
        ),
      ],
    );
  }
}

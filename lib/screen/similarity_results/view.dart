import 'dart:io';

import 'package:face_features/bloc/similarity_results/similarity_results_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimilarityResultsView extends StatefulWidget {
  const SimilarityResultsView({Key? key}) : super(key: key);

  @override
  _SimilarityResultsState createState() => _SimilarityResultsState();
}

class _SimilarityResultsState extends State<SimilarityResultsView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SimilarityResultsBloc, SimilarityResultsState>(
        listener: (BuildContext context, SimilarityResultsState state) => _listenState(context, state),
        child: BlocBuilder<SimilarityResultsBloc, SimilarityResultsState>(
          builder: (BuildContext context, SimilarityResultsState state) {
            return _buildState(context, state);
          },
        ),
      ),
    );
  }

  void _listenState(BuildContext context, SimilarityResultsState state) {

  }

  Widget _buildState(BuildContext context, SimilarityResultsState state) {
    if (state is InitialSimilarityResultsState) {
      return Center(
        child: Image.file(File(state.similarity.celebImagePath)),
      );
    } else {
      return const SizedBox();
    }
  }
}

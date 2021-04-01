import 'package:face_features/bloc/similarity_results/similarity_results_bloc.dart';
import 'package:face_features/model/celeb_similarity_result.dart';
import 'package:face_features/screen/similarity_results/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimilarityResultsPage extends StatelessWidget {
  const SimilarityResultsPage({Key? key, required CelebSimilarityResult similarityResult})
      : _similarityResult = similarityResult,
        super(key: key);

  final CelebSimilarityResult _similarityResult;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SimilarityResultsBloc>(
      create: (_) => SimilarityResultsBloc(similarityResult: _similarityResult),
      child: const SimilarityResultsView(),
    );
  }
}

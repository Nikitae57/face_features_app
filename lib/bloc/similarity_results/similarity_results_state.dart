part of 'similarity_results_bloc.dart';

@immutable
abstract class SimilarityResultsState {}

class InitialSimilarityResultsState extends SimilarityResultsState {
  InitialSimilarityResultsState(this.similarity);
  final CelebSimilarityResult similarity;
}

class SimilarityResultsUploadingNewImageState extends SimilarityResultsState {}
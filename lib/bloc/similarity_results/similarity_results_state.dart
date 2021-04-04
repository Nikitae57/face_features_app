part of 'similarity_results_bloc.dart';

@immutable
abstract class SimilarityResultsState {}

class InitialSimilarityResultsState extends SimilarityResultsState {
  InitialSimilarityResultsState(this.similarity);
  final CelebSimilarityResult similarity;
}

class SimilarityResultsIdleState extends SimilarityResultsState {
  SimilarityResultsIdleState(this.similarity);
  final CelebSimilarityResult similarity;
}

class SimilarityResultsUploadingNewImageState extends SimilarityResultsState {}

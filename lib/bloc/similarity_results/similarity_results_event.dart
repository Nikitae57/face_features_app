part of 'similarity_results_bloc.dart';

@immutable
abstract class SimilarityResultsEvent {}

class SimilarityResultsIdlingEvent extends SimilarityResultsEvent {}

class SimilarityResultsUploadNewImageEvent extends SimilarityResultsEvent {}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:face_features/model/celeb_similarity_result.dart';
import 'package:meta/meta.dart';

part 'similarity_results_event.dart';
part 'similarity_results_state.dart';

class SimilarityResultsBloc extends Bloc<SimilarityResultsEvent, SimilarityResultsState> {
  SimilarityResultsBloc({required CelebSimilarityResult similarityResult})
      : super(InitialSimilarityResultsState(similarityResult));


  @override
  Stream<SimilarityResultsState> mapEventToState(SimilarityResultsEvent event) async* {
    if (event is SimilarityResultsUploadNewImageEvent) {
      yield SimilarityResultsUploadingNewImageState();
    }
  }
}

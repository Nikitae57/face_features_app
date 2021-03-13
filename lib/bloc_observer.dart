import 'package:bloc/bloc.dart';

class FaceFeaturesBlocObserver extends BlocObserver {
  @override
  // ignore: always_specify_types
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }
}

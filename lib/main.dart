import 'package:face_features/app.dart';
import 'package:face_features/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const FaceFeaturesApp());
  Bloc.observer = FaceFeaturesBlocObserver();
}


import 'package:face_features/router_generator.dart';
import 'package:flutter/material.dart';

class FaceFeaturesApp extends StatelessWidget {
  const FaceFeaturesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: RouteGenerator.IMG_CHOICE_ROUTE,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
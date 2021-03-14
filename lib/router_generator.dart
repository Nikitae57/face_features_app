import 'package:face_features/model/user_photo.dart';
import 'package:face_features/screen/image_choice/page.dart';
import 'package:face_features/screen/image_verification/page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String IMG_CHOICE_ROUTE = '/';
  static const String IMG_VERIFICATION_ROUTE = '/img_verification';
  static const String IMG_PROCESSING_ROUTE = '/img_processing';
  static const String IMG_PROCESSING_ERROR_ROUTE = '/img_processing_error';
  static const String IMG_PROCESSING_RESULT_ROUTE = '/img_processing_result';

  // Хотел сделать механизм валидации навигации (переходы только на разрешенные
  // для текущего пути экраны), но получить текущий путь - нетривиальная задача

  // final Map<String, List<String>> _currentScreenToAllowedDestinations = <String, List<String>>{
  //   IMG_CHOICE_ROUTE: <String>[IMG_VERIFICATION_ROUTE],
  //   IMG_VERIFICATION_ROUTE: <String>[IMG_CHOICE_ROUTE, IMG_PROCESSING_ROUTE],
  //   IMG_PROCESSING_ROUTE: <String>[IMG_PROCESSING_ERROR_ROUTE, IMG_PROCESSING_RESULT_ROUTE],
  //   IMG_PROCESSING_ERROR_ROUTE: <String>[IMG_CHOICE_ROUTE],
  //   IMG_PROCESSING_RESULT_ROUTE: <String>[IMG_CHOICE_ROUTE]
  // };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name == null) {
      throw ArgumentError('Tried to generate named route, but name us null');
    }

    final String destinationName = settings.name!;
    final dynamic args = settings.arguments;

    switch (destinationName) {
      case IMG_CHOICE_ROUTE:
        return _imgChoicePage();
      case IMG_VERIFICATION_ROUTE:
        return _imgVerificationPage(args);
      // case IMG_PROCESSING_ROUTE:
      //   return _imgProcessingPage();
      default:
        throw ArgumentError('Unknown route name: $destinationName');
    }
  }

  static Future<dynamic> navigate({required String to, required BuildContext context, dynamic args}) async {
    return Navigator.of(context).pushNamed(to, arguments: args);
  }

  static Future<dynamic> navigateToImgVerification({
    required BuildContext context,
    required UserImage image
  }) async {
    return navigate(to: IMG_VERIFICATION_ROUTE, context: context, args: image);
  }

  static Route<ImageChoicePage> _imgChoicePage() {
    return NoAnimationMaterialPageRoute<ImageChoicePage>(builder: (_) => const ImageChoicePage());
  }

  static Route<ImageVerificationPage> _imgVerificationPage(dynamic args) {
    if (args is UserImage) {
      return NoAnimationMaterialPageRoute<ImageVerificationPage>(
        builder: (_) => ImageVerificationPage(
          image: args,
        ),
      );
    } else {
      throw ArgumentError('Invalid args of type ${args.runtimeType}. Needed type: $UserImage');
    }
  }
}

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(builder: builder, maintainState: maintainState, settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {

    return child;
  }
}

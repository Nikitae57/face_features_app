import 'dart:io';

import 'package:face_features/bloc/image_verification/image_verification_bloc.dart';
import 'package:face_features/model/user_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageVerificationView extends StatelessWidget {
  const ImageVerificationView({Key? key, required UserImage image})
      : _image = image,
        super(key: key);

  final UserImage _image;
  static const double _borderRadiusVal = 48.0;
  static const Radius _radius = Radius.circular(_borderRadiusVal);
  static const double _controlButtonsHeight = 150.0;

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: BlocListener<ImageVerificationBloc, ImageVerificationState>(
          listener: (BuildContext context, ImageVerificationState state) => _listenState(context, state),
          child: BlocBuilder<ImageVerificationBloc, ImageVerificationState>(
            builder: (BuildContext context, ImageVerificationState state) => _buildState(context, state),
          ),
        ),
      );
  }

  Widget _buildState(BuildContext context, ImageVerificationState state) {
    return _initialState(context);
  }

  void _listenState(BuildContext context, ImageVerificationState state) {
    if (state is ImageDeniedState) {
      Navigator.of(context).pop();
    }
  }

  Widget _initialState(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: <MaterialColor>[Colors.purple, Colors.blue],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _img(context),
          _controlTile(context),
        ],
      ),
    );
  }

  Widget _img(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
      top: 100.0,
      width: screenWidth,
      height: screenWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(_radius),
          child: Image.file(
            File(_image.path),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _controlTile(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      bottom: 0.0,
      left: 10.0,
      right: 10.0,
      child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: _radius, topRight: _radius),
          child: Container(
            color: Colors.white,
            height: screenHeight * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[_confirmationText(context), const Spacer(), _controlButtons(context)],
            ),
          )),
    );
  }

  Widget _confirmationText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
      child: Text(
        'Are you sure, you want to send this image?',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _controlButtons(BuildContext context) {
    return Stack(children: <Widget>[
      Row(
        children: <Widget>[_cancelControlBtn(context), _acceptControlBtn(context)],
      )
    ]);
  }

  Widget _cancelControlBtn(BuildContext context) {
    const double cancelIconSize = 64.0;
    final ImageVerificationBloc bloc = context.read<ImageVerificationBloc>();


    return Expanded(
      flex: 2,
      child: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.purple,
          ),
          iconSize: cancelIconSize,
          onPressed: () => bloc.add(ImageDeniedEvent())
      ),
    );
  }

  Widget _acceptControlBtn(BuildContext context) {
    final ImageVerificationBloc bloc = context.read<ImageVerificationBloc>();

    const double acceptIconSize = 86.0;
    return Expanded(
      flex: 4,
      child: GestureDetector(
        onTap: () => bloc.add(ImageVerifiedEvent()),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: _radius),
          child: Container(
            // width: screenWidth / 2 + _borderRadius / 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <MaterialColor>[Colors.purple, Colors.blue],
              ),
            ),
            height: _controlButtonsHeight,
            child: const Center(
              child: Icon(
                Icons.check,
                size: acceptIconSize,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

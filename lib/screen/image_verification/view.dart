import 'dart:io';

import 'package:face_features/bloc/image_verification/image_verification_bloc.dart';
import 'package:face_features/model/user_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageVerificationView extends StatefulWidget {
  const ImageVerificationView({Key? key, required UserImage image})
      : _image = image,
        super(key: key);

  final UserImage _image;

  @override
  _ImageVerificationViewState createState() => _ImageVerificationViewState();
}

class _ImageVerificationViewState extends State<ImageVerificationView>
    with SingleTickerProviderStateMixin {

  static const double _borderRadiusVal = 48.0;
  static const Radius _radius = Radius.circular(_borderRadiusVal);
  static const double _controlButtonsHeight = 150.0;
  static const double _imgTopOffset = 100.0;

  static const Duration _transitionDuration = Duration(milliseconds: 500);
  static const double _maxControlsHeightPercent = 0.3;
  
  late final AnimationController _animationController;
  late final CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _transitionDuration);
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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

  Future<void> _animateIn() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _animationController.forward();
  }

  void _animateOut() => _animationController.reverse();

  Widget _buildState(BuildContext context, ImageVerificationState state) {
    if (state is ImageVerificationInitialState) {
      return _initialState(context);      
    }
    
    if (state is ImageDeniedState) {
      return _imageDeniedState(context);
    }
    return _initialState(context);
  }

  void _listenState(BuildContext context, ImageVerificationState state) {
    if (state is ImageDeniedState) {
      _navigateBack(context);
    }
  }

  Future<void> _navigateBack(BuildContext context) async {
    await Future<void>.delayed(_transitionDuration);
    // _animationController.dispose();
    Navigator.of(context).pop();
  }

  Widget _initialState(BuildContext context) {
    _animateIn();
    return _screen();
  }

  Widget _imageDeniedState(BuildContext context) {
    _animateOut();
    return _screen();
  }

  Widget _screen() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, _) {
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
      },
    );
  }

  Widget _img(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imgSlide = -(1 - _animation.value) * screenWidth * 1.5;

    return Positioned(
      top: _imgTopOffset + imgSlide,
      width: screenWidth,
      height: screenWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(_radius),
          child: Image.file(
            File(widget._image.path),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _controlTile(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double controlsSlide = -(1 - _animation.value) * _maxControlsHeightPercent * screenHeight;

    return Positioned(
      bottom: controlsSlide,
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

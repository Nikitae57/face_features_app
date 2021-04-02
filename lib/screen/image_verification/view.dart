import 'dart:io';
import 'dart:math';

import 'package:face_features/bloc/image_verification/image_verification_bloc.dart';
import 'package:face_features/model/user_photo.dart';
import 'package:face_features/route_generator.dart';
import 'package:face_features/widget/item_fader.dart';
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

class _ImageVerificationViewState extends State<ImageVerificationView> with TickerProviderStateMixin {
  static const double _borderRadiusVal = 48.0;
  static const Radius _radius = Radius.circular(_borderRadiusVal);
  static const double _padding = 8.0;

  static const Duration _fadeDuration = Duration(milliseconds: 100);

  late final List<GlobalKey<ItemFaderState>> _keys;

  @override
  void initState() {
    super.initState();
    _keys = List<GlobalKey<ItemFaderState>>.generate(4, (_) => GlobalKey<ItemFaderState>());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ImageVerificationBloc, ImageVerificationState>(
        listener: (BuildContext context, ImageVerificationState state) => _listenState(context, state),
        child: BlocBuilder<ImageVerificationBloc, ImageVerificationState>(
          builder: (BuildContext context, ImageVerificationState state) {
            return WillPopScope(
                child: _buildState(context, state),
                onWillPop: () async {
                  await _navigateBack(context);
                  return true;
                }
            );
          },
        ),
      ),
    );
  }

  Future<void> _animateIn() async {
    for (final GlobalKey<ItemFaderState> key in _keys) {
      await Future<void>.delayed(_fadeDuration);
      key.currentState?.show();
    }
  }

  Future<void> _animateOut() async {
    for (int i = _keys.length - 1; i >= 0; i--) {
      _keys[i].currentState?.hide();
      await Future<void>.delayed(_fadeDuration);
    }
  }

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
    } else if (state is ImageVerifiedState) {
      _navigateToImageProcessing(context, state.image);
    }
  }

  Future<void> _navigateBack(BuildContext context) async {
    await _animateOut();
    Navigator.of(context).pop();
  }

  Future<void> _navigateToImageProcessing(BuildContext context, UserImage image) async {
    // await _animateOut();
    RouteGenerator.navigateToImgProcessing(context: context, image: image);
  }

  Widget _initialState(BuildContext context) {
    _animateIn();
    return _screen();
  }

  Widget _imageDeniedState(BuildContext context) {
    return _screen();
  }

  Widget _screen() {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        final Widget child;
        if (orientation == Orientation.portrait) {
          child = Column(children: _screenContent());
        } else {
          child = Row(
              children: <Widget>[..._screenContent(), const Spacer()],
              crossAxisAlignment: CrossAxisAlignment.end
          );
        }

        return Container(
          height: double.infinity,
          width: double.infinity,

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: <MaterialColor>[Colors.purple, Colors.blue],
            ),
          ),
          child: child,
        );
      },
    );
  }

  List<Widget> _screenContent() {
    return <Widget>[
      const Spacer(),
      _img(context),
      const Spacer(),
      _controlTile(context),
    ];
  }

  Widget _img(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imgSize = min(screenWidth, screenHeight) * 0.9;

    return Center(
      child: ItemFader(
        key: _keys[0],
        direction: ItemFaderInDirection.DOWN,
        offset: 200,
        child: SizedBox(
          height: imgSize,
          width: imgSize,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(_radius),
            child: Image.file(
              File(widget._image.path),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _controlTile(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        // final EdgeInsets insets;
        // if (orientation == Orientation.portrait) {
        //   insets = const EdgeInsets.symmetric(horizontal: _padding);
        // } else {
        //   insets = const EdgeInsets.symmetric(vertical: _padding);
        // }
        final double screenHeight = MediaQuery.of(context).size.height;
        final double screenWidth = MediaQuery.of(context).size.width;
        final double tileSize = min(screenWidth, screenHeight) * 0.9;


        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: _padding),
          child: ItemFader(
            key: _keys[1],
            child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: _radius, topRight: _radius),
                child: Container(
                  width: tileSize,
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _confirmationText(context),
                      _controlButtons(context),
                    ],
                  ),
                )),
          ),
        );
      },
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

    return Row(
      children: <Widget>[
        _cancelControlBtn(context),
        _acceptControlBtn(context),
      ],
    );
  }

  Widget _cancelControlBtn(BuildContext context) {
    final ImageVerificationBloc bloc = context.read<ImageVerificationBloc>();
    const double cancelIconSize = 64.0;

    return Expanded(
      flex: 2,
      child: ItemFader(
        key: _keys[3],
        child: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.purple,
            ),
            iconSize: cancelIconSize,
            onPressed: () => bloc.add(ImageDeniedEvent())),
      ),
    );
  }

  Widget _acceptControlBtn(BuildContext context) {
    final ImageVerificationBloc bloc = context.read<ImageVerificationBloc>();
    const double acceptIconSize = 86.0;

    return Expanded(
      flex: 4,
      child: ItemFader(
        key: _keys[2],
        child: GestureDetector(
          onTap: () => bloc.add(ImageVerifiedEvent()),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: _radius),
            child: Container(
              // width: screenWidth / 2 + _borderRadius / 2,
              decoration: _btnGradient(),
              // height: btnHeight,
              child: const Center(
                child: Icon(
                  Icons.check_rounded,
                  size: acceptIconSize,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _btnGradient() {
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    final List<MaterialColor> colors;
    if (isPortrait) {
      colors = <MaterialColor>[Colors.purple, Colors.blue];
    } else {
      colors = <MaterialColor>[Colors.blue, Colors.purple];
    }

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: colors,
      ),
    );
  }
}

import 'package:face_features/bloc/image_choice/image_choice_bloc.dart';
import 'package:face_features/model/user_photo.dart';
import 'package:face_features/router_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImageChoiceView extends StatefulWidget {
  const ImageChoiceView({Key? key}) : super(key: key);

  @override
  _ImageChoiceViewState createState() => _ImageChoiceViewState();
}

class _ImageChoiceViewState extends State<ImageChoiceView> with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();

  static const double _borderRadiusVal = 48.0;
  static const double _iconSize = 124.0;

  static const int _transitionDurationMs = 400;
  static const Duration _transitionDuration = Duration(milliseconds: _transitionDurationMs);
  late final AnimationController _animationController;
  late final CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _transitionDuration);
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCirc);
  }

  @override
  void dispose() {
    print('DISPOSE');
    _animationController.dispose();
    super.dispose();
  }

  void _animateIn() {
    _animationController.forward();
  }

  void _animateOut() {
    _animationController.reverse(from: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ImageChoiceBloc, ImageChoiceState>(
        listener: (BuildContext context, ImageChoiceState state) => _listenState(context, state),
        child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: <Color>[Colors.purple, Colors.blue],
            ),
          ),
          child: BlocBuilder<ImageChoiceBloc, ImageChoiceState>(
            bloc: BlocProvider.of<ImageChoiceBloc>(context),
            builder: (BuildContext context, ImageChoiceState state) => _buildState(context, state),
          ),
        ),
      ),
    );
  }

  Widget _buildState(BuildContext context, ImageChoiceState state) {
    if (state is ImageChoiceCameraState) {
      return _cameraState(context);
    } else if (state is ImageChoiceGalleryState) {
      return _galleryState(context);
    } else if (state is ImageChoiceInitialState) {
      return _initialState(context);
    } else if (state is ImageChoiceGotFileState) {
      return _gotFileState(context, state.image);
    } else if (state is ImageChoicePoppingBackState) {
      _animationController.reset();
      return _initialState(context);
    } else if (state is ImageChoiceErrorState) {
      return _errorState(context, state.message);
    } else {
      return _errorState(context, 'Unknown state');
    }
  }

  void _listenState(BuildContext context, ImageChoiceState state) {
    if (state is ImageChoiceGotFileState) {
      _navigateToVerificationScreen(context, state.image);
    }
  }

  Widget _initialState(BuildContext context) {
    _animateIn();
    return _imgSourceButtons();
  }

  Widget _gotFileState(BuildContext context, UserImage image) {
    _animateOut();
    return _imgSourceButtons();
  }

  Widget _imgSourceButtons() {
    final double screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, _) {
        final double slide = (1 - _animation.value) * screenWidth / 2;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Opacity(
              opacity: 1.0,
              child: Transform.translate(
                offset: Offset(-slide, 0),
                child: _pickFileButton(context),
              ),
            ),
            Opacity(
              opacity: 1.0,
              child: Transform.translate(
                offset: Offset(slide, 0),
                child: _cameraButton(context),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _navigateToVerificationScreen(BuildContext context, UserImage image) async {
    await Future<void>.delayed(_transitionDuration);
    await RouteGenerator.navigateToImgVerification(context: context, image: image);
    BlocProvider.of<ImageChoiceBloc>(context).add(ImageChoiceResetEvent());
  }


  Widget _errorState(BuildContext context, String message) {
    return _initialState(context);
  }

  Widget _cameraState(BuildContext context) {
    final ImageChoiceBloc bloc = context.read<ImageChoiceBloc>();
    _picker
        .getImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front)
        .then((PickedFile? file) => bloc.add(ImageChoicePickerReturnedEvent(file)));

    return _initialState(context);
  }

  Widget _galleryState(BuildContext context) {
    final ImageChoiceBloc bloc = context.read<ImageChoiceBloc>();

    _picker
        .getImage(source: ImageSource.gallery, preferredCameraDevice: CameraDevice.front)
        .then((PickedFile? file) => bloc.add(ImageChoicePickerReturnedEvent(file)));

    return _initialState(context);
  }

  Widget _cameraButton(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_borderRadiusVal),
      child: ColoredBox(
        color: Colors.white,
        child: IconButton(
          icon: const Icon(
            Icons.camera,
            color: Colors.purpleAccent,
          ),
          iconSize: _iconSize,
          onPressed: () => _takePhoto(context),
        ),
      ),
    );
  }

  Widget _pickFileButton(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_borderRadiusVal),
      child: ColoredBox(
        color: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.insert_drive_file),
          color: Colors.blue,
          iconSize: _iconSize,
          onPressed: () => _pickPhotoFromGallery(context),
        ),
      ),
    );
  }

  void _takePhoto(BuildContext context) {
    BlocProvider.of<ImageChoiceBloc>(context).add(ImageChoiceTakePhotoEvent());
  }

  void _pickPhotoFromGallery(BuildContext context) {
    BlocProvider.of<ImageChoiceBloc>(context).add(ImageChoicePickPhotoFromGalleryEvent());
  }
}

import 'package:face_features/bloc/image_choice/image_choice_bloc.dart';
import 'package:face_features/router_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImageChoiceView extends StatelessWidget {
  ImageChoiceView({Key? key}) : super(key: key);

  static const double _iconSize = 80.0;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick an image')),
      body: BlocListener<ImageChoiceBloc, ImageChoiceState>(
        listener: (BuildContext context, ImageChoiceState state) => _listenState(context, state),
        child: Center(
          child: BlocBuilder<ImageChoiceBloc, ImageChoiceState>(
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
    } else if (state is ImageChoiceErrorState){
      return _errorState(context, state.message);
    } else {
      return _errorState(context, 'Unknown state');
    }
  }

  Widget _initialState(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _pickFileButton(context),
        _cameraButton(context),
      ],
    );
  }

  void _listenState(BuildContext context, ImageChoiceState state) {
    final ImageChoiceBloc bloc = context.read<ImageChoiceBloc>();

    if (state is ImageChoiceErrorState) {
      _showSnackBar(context, state.message);
    } else if (state is ImageChoiceGotFileState) {
      bloc.add(ImageChoiceResetEvent());
      RouteGenerator.navigateToImgVerification(context: context, image: state.image);
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _errorState(BuildContext context, String message) {
    // Showing error in listener
    return _initialState(context);
  }

  Widget _cameraState(BuildContext context) {
    final ImageChoiceBloc bloc = context.read<ImageChoiceBloc>();
    _picker.getImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front
    ).then((PickedFile? file) => bloc.add(ImageChoicePickerReturnedEvent(file!)));

    return const CircularProgressIndicator();
  }

  Widget _galleryState(BuildContext context) {
    final ImageChoiceBloc bloc = context.read<ImageChoiceBloc>();

    _picker.getImage(
        source: ImageSource.gallery,
        preferredCameraDevice: CameraDevice.front
    ).then((PickedFile? file) => bloc.add(ImageChoicePickerReturnedEvent(file!)));

    return const CircularProgressIndicator();
  }

  Widget _cameraButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.camera),
      color: Colors.deepPurple,
      iconSize: _iconSize,
      onPressed: () => _takePhoto(context),
    );
  }

  Widget _pickFileButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.insert_drive_file_rounded),
      color: Colors.redAccent,
      iconSize: _iconSize,
      onPressed: () => _pickPhotoFromGallery(context),
    );
  }

  void _takePhoto(BuildContext context) {
    context.read<ImageChoiceBloc>().add(ImageChoiceTakePhotoEvent());
  }

  void _pickPhotoFromGallery(BuildContext context) {
    context.read<ImageChoiceBloc>().add(ImageChoicePickPhotoFromGalleryEvent());
  }
}

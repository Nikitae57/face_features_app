import 'dart:io';

import 'package:face_features/bloc/similarity_results/similarity_results_bloc.dart';
import 'package:face_features/model/celeb_similarity_result.dart';
import 'package:face_features/route_generator.dart';
import 'package:face_features/screen/util.dart';
import 'package:face_features/widget/item_fader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimilarityResultsView extends StatefulWidget {
  const SimilarityResultsView({Key? key}) : super(key: key);

  @override
  _SimilarityResultsState createState() => _SimilarityResultsState();
}

class _SimilarityResultsState extends State<SimilarityResultsView> with TickerProviderStateMixin {
  double _celebImageAlpha = 0.5;
  late final List<GlobalKey<ItemFaderState>> _keys;

  static const Duration _transitionDuration = Duration(milliseconds: 700);
  static const Duration _fadeDuration = Duration(milliseconds: 100);
  late final AnimationController _opacityAnimationController;
  late final CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();
    _opacityAnimationController = AnimationController(vsync: this, duration: _transitionDuration);
    _animation = CurvedAnimation(parent: _opacityAnimationController, curve: Curves.easeInOutCirc);
    _keys = List<GlobalKey<ItemFaderState>>.generate(2, (_) => GlobalKey<ItemFaderState>());
  }
  
  @override
  void dispose() {
    _opacityAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SimilarityResultsBloc, SimilarityResultsState>(
        listener: (BuildContext context, SimilarityResultsState state) => _listenState(context, state),
        child: BlocBuilder<SimilarityResultsBloc, SimilarityResultsState>(
          builder: (BuildContext context, SimilarityResultsState state) {
            return _view(context, state);
          },
        ),
      ),
    );
  }

  Widget _view(BuildContext context, SimilarityResultsState state) {
    return WillPopScope(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: getBackgroundGradient(context),
        child: _buildState(context, state),
      ),
      onWillPop: () async {
        RouteGenerator.navigateToImageChoice(context: context, clearStack: true);
        return true;
      },
    );
  }

  Future<void> _listenState(BuildContext context, SimilarityResultsState state) async {
    if (state is SimilarityResultsUploadingNewImageState) {
      await _navigateToImageChoice();
    }
  }

  Widget _buildState(BuildContext context, SimilarityResultsState state) {
    if (state is InitialSimilarityResultsState) {
      _animateIn(context);
      return _gotSimilarityResults(context, state.similarity);
    } else if (state is SimilarityResultsIdleState) {
      return _gotSimilarityResults(context, state.similarity);
    } else {
      return const SizedBox();
    }
  }

  Future<void> _animateIn(BuildContext context) async {
    for (final GlobalKey<ItemFaderState> key in _keys) {
      await Future<void>.delayed(_fadeDuration);
      key.currentState?.show();
    }
    await _opacityAnimationController.forward();
    _opacityAnimationController.reverse();
    context.read<SimilarityResultsBloc>().add(SimilarityResultsIdlingEvent());
  }

  Future<void> _animateOut() async {
    for (int i = _keys.length - 1; i >= 0; i--) {
      _keys[i].currentState?.hide();
      await Future<void>.delayed(_fadeDuration);
    }
  }

  Future<void> _navigateToImageChoice() async {
    await _animateOut();
    RouteGenerator.navigateToImageChoice(context: context, clearStack: true);
  }

  Widget _gotSimilarityResults(BuildContext context, CelebSimilarityResult result) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          ItemFader(
            key: _keys[0],
            child: _imageTile(context, result),
            direction: ItemFaderInDirection.DOWN,
            offset: 200,
          ),
          ItemFader(
            key: _keys[1],
            child: _uploadNewImageBtn(),
          ),
        ],
      ),
    );
  }

  Widget _imageTile(BuildContext context, CelebSimilarityResult result) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, _) {
        // Анимация запускается вперед, потом обратно назад. Если не проверять на 0,
        // то пользователь не сможет двигать ползунок т.к. значение _celebImageAlpha будет перезаписано
        if (!(_animation.value == 0.0)) {
          _celebImageAlpha = _animation.value;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              result.celebName,
              style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w300),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
              child: Stack(
                children: <Widget>[
                  Image.file(File(result.userImagePath)),
                  Opacity(
                    opacity: _celebImageAlpha,
                    child: Image.file(File(result.celebImagePath)),
                  ),
                ],
              ),
            ),
            Slider.adaptive(
              value: _celebImageAlpha,
              onChanged: (double value) {
                setState(() {
                  _celebImageAlpha = value;
                });
              },
              min: 0.0,
              max: 1.0,
            ),
          ],
        );
      },
    );
  }

  Widget _uploadNewImageBtn() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.replay),
            label: const Text(
              'Upload another image',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              final SimilarityResultsBloc bloc = context.read<SimilarityResultsBloc>();
              bloc.add(SimilarityResultsUploadNewImageEvent());
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

enum ItemFaderInDirection { UP, DOWN }

class ItemFader extends StatefulWidget {
  ItemFader(
      {Key? key,
      required Widget child,
      ItemFaderInDirection direction = ItemFaderInDirection.UP,
      int durationMs = 300,
      double offset = 100.0,
      Cubic curve = Curves.easeInOut})
      : _child = child,
        _duration = Duration(milliseconds: durationMs),
        _curve = curve,
        _dy = direction == ItemFaderInDirection.UP ? 1.0 : -1.0,
        _offset = offset,
        super(key: key);

  final Duration _duration;
  final Cubic _curve;
  final Widget _child;
  final double _dy;
  final double _offset;

  @override
  ItemFaderState createState() => ItemFaderState();
}

class ItemFaderState extends State<ItemFader> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  void show() {
    _animationController.forward();
  }

  void hide() {
    _animationController.reverse();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: widget._duration);
    _animation = CurvedAnimation(parent: _animationController, curve: widget._curve);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(0, widget._dy * widget._offset * (1.0 - _animation.value)),
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
      child: widget._child,
    );
  }
}

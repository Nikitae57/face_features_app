import 'package:flutter/material.dart';

class ImageSourceButton extends StatelessWidget {
  const ImageSourceButton({
    Key? key,
    VoidCallback? onPressed,
    required Icon icon,
    double iconSize = 128,
  })  : _onPressed = onPressed,
        _icon = icon,
        _iconSize = iconSize,
        super(key: key);

  final VoidCallback? _onPressed;

  static const double _borderRadiusVal = 48.0;
  final double _iconSize;
  final Icon _icon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_borderRadiusVal),
      child: ColoredBox(
        color: Colors.white,
        child: IconButton(
          icon: _icon,
          iconSize: _iconSize,
          onPressed: _onPressed,
        ),
      ),
    );
  }
}

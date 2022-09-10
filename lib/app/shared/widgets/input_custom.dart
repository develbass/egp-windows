import 'package:flutter/material.dart';

class InputCustom extends StatelessWidget {
  final double? radius;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final TextField? input;
  final double? width;
  final double height;
  final Color borderColor;

  const InputCustom({
    Key? key,
    this.radius = 0.0,
    @required this.padding,
    this.backgroundColor,
    @required this.input,
    this.width,
    this.height = 60,
    this.borderColor = Colors.transparent
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          radius ?? 0,
        ),
        border: Border.all(color: borderColor),
      ),
      child: Center(child: input),
    );
  }
}

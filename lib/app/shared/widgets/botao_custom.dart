import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nice_buttons/nice_buttons.dart';

/**
 * onTap deve ser sempre async
 */
class BotaoCustom extends StatefulWidget {
  final AsyncCallback onTap;
  final Color backgroundColor;
  final double? radius;
  final double? width;
  final double? heigth;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final bool? progress;
  final Color? borderColor;

  const BotaoCustom({
    Key? key,
    required this.onTap,
    required this.backgroundColor,
    this.radius = 0.0,
    this.width,
    this.heigth,
    this.margin,
    this.padding,
    required this.child, 
    this.progress, this.borderColor,
  }) : super(key: key);

  @override
  State<BotaoCustom> createState() => _BotaoCustomState();
}

class _BotaoCustomState extends State<BotaoCustom> {
  @override
  Widget build(BuildContext context) {
    return NiceButtons(
      stretch: true,
      progress: widget.progress ?? true,
      startColor: widget.backgroundColor,
      endColor: widget.backgroundColor,
      borderRadius: widget.radius ?? 25.0,
      borderColor: widget.borderColor ?? Colors.transparent,
      gradientOrientation: GradientOrientation.Horizontal,
      onTap: (finish) async{
        await widget.onTap();
        finish();
      },
      child: widget.child,
      height: widget.heigth ?? 60,
    );
  }
}

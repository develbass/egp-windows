import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'input_custom.dart';

class InputTradicional extends StatelessWidget {
  final TextEditingController? controller;
  final bool? obscure;
  final String? label;
  final Color? cor;
  final Color? borderColor;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int? maxLength;
  final TextCapitalization? textCapitalization;
  final String? placeholder;
  final bool? enabled;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final double? radius;
  final EdgeInsets? padding;
  final EdgeInsets? paddingLabel;
  final Widget? suffixIcon;
  final bool? autofocus;
  final int? minLines;
  final int? maxLines;
  final double? height;
  final TextStyle? labelStyle;

  const InputTradicional({
    Key? key,
    this.controller,
    this.obscure = false,
    this.label,
    this.cor,
    this.inputFormatters,
    this.keyboardType,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.placeholder,
    this.enabled = true,
    this.focusNode,
    this.onChanged,
    this.borderColor,
    this.radius = 5,
    this.padding,
    this.paddingLabel,
    this.suffixIcon,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.height,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _label() {
      if (label != null) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: paddingLabel ?? EdgeInsets.all(0),
            child: Text(
              label ?? "",
              style: labelStyle,
            ),
          ),
        );
      } else {
        return Container();
      }
    }

    return Container(
      child: Column(
        children: <Widget>[
          _label(),
          SizedBox(
            height: 5,
          ),
          InputCustom(
            backgroundColor: cor != null ? cor : Colors.grey[300],
            padding: padding == null
                ? EdgeInsets.only(left: 10, right: 10)
                : padding,
            radius: radius,
            borderColor: borderColor ?? Colors.white,
            height: height ?? 50,
            input: TextField(
              autofocus: autofocus ?? false,
              focusNode: focusNode,
              enabled: enabled,
              onChanged: onChanged,
              obscureText: obscure ?? false,
              controller: controller,
              inputFormatters: inputFormatters,
              keyboardType: keyboardType,
              minLines: minLines ?? 1,
              maxLines: maxLines ?? 1,
              decoration: InputDecoration(
                suffixIcon: suffixIcon,
                border: InputBorder.none,
                hintText: placeholder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

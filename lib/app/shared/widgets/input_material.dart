import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputMaterial extends StatelessWidget {
  final TextEditingController? controller;
  final bool? obscure;
  final String? label;
  final Color? cor;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? margin;
  final Icon? suffixIcon;
  final bool? enabled;
  final String? hintText;

  const InputMaterial({
    Key? key,
    this.controller,
    this.obscure = false,
    this.label,
    this.cor = Colors.white,
    this.inputFormatters,
    this.keyboardType,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.margin,
    this.suffixIcon,
    this.enabled = true,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin != null ? margin : EdgeInsets.all(0),
      child: TextField(
        enabled: enabled,
        controller: controller,
        obscureText: obscure ?? false,
        style: TextStyle(color: cor),
        cursorColor: cor,
        maxLength: maxLength,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          labelText: label,
          hintText: hintText,
          labelStyle: TextStyle(color: cor),
          focusColor: cor,
          fillColor: cor,
          hoverColor: cor,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: cor ?? Colors.white,
          )),
          disabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: cor ?? Colors.white)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: cor ?? Colors.white)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: cor ?? Colors.white,
              width: 0.5,
              style: BorderStyle.none,
            ),
          ),
        ),
      ),
    );
  }
}

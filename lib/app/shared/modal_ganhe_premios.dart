
import 'package:app_windows/app/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalGanhePremios {
  emBranco(context, {backgroundColor, required Widget child, double? height, double? width}) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {

          return Center(
            child: Material(
              borderRadius: BorderRadius.circular(10),
              color: backgroundColor ?? Colors.white,
              child: Container(
                height: height ?? tamanhaDaTela.height,
                width: width ?? tamanhaDaTela.width,
                child: child,
              ),
            ),
          );
        });
  }
}

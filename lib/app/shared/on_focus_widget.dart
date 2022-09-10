import 'package:flutter/material.dart';

class OnFocusWidget extends StatefulWidget {
  final Widget child;

  const OnFocusWidget({Key? key, required this.child}) : super(key: key);

  @override
  _OnFocusWidgetState createState() => _OnFocusWidgetState();
}

class _OnFocusWidgetState extends State<OnFocusWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: widget.child,
    );
  }
}
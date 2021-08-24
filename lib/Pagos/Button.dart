import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Widget child;
  final Function onClick;

  Button({this.child, this.onClick});

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: Colors.black12),
      child: Material(
        color: hexToColor("#41aa5e"),
        child: InkWell(
            onTap: onClick,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? icon;
  final Size? size;
  final String? text;
  const CustomOutlineButton({
    this.onPressed,
    this.icon,
    this.size,
    this.text
});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size!.height,
      width: size!.width,
      child: OutlineButton.icon(
        onPressed: onPressed,
        highlightColor: Colors.black,
        borderSide: BorderSide(width: 1.5, color: Colors.black),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.zero
        ),
        icon: icon ?? Container(),
        label: Text(text!,
        style: Theme.of(context).textTheme.caption!.copyWith(
          fontSize: 18.0,
          fontWeight: FontWeight.w200,
          color: Colors.black
        ),
        ),
        color: Colors.white,
        highlightedBorderColor: Colors.white,
        splashColor: Theme.of(context).accentColor,

      ),
    );
  }
}

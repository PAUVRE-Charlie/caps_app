import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/images/caps_gif.gif",
        height: 125.0,
        width: 125.0,
      ),
    );
  }
}

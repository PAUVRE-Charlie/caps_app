import 'package:flutter/material.dart';

import '../data.dart';

class Background extends StatelessWidget {
  const Background({Key key, this.image, this.height}) : super(key: key);

  final String image;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kBackgroundBaseColor, kBackgroundSecondColor]),
          ),
        ),
        image == null
            ? SizedBox()
            : Align(
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: 0.3,
                  child: Image(
                    height: height ?? MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                    image: AssetImage(image),
                  ),
                ),
              )
      ],
    );
  }
}

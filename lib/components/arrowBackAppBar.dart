import 'package:flutter/material.dart';

import '../data.dart';

class ArrowBackAppBar extends StatelessWidget {
  const ArrowBackAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: kSecondaryColor),
        onPressed: () {
          Navigator.of(context)
              .pop(); // delete this line when finish editing it and decomment the one in the onConfirm of startMatchMethod
        });
  }
}

import 'package:flutter/material.dart';

import '../data.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField(
      {Key key,
      this.onChanged,
      this.validator,
      this.hintText,
      this.obscureText = false,
      this.textInputType,
      this.initialValue})
      : super(key: key);

  final Function onChanged;
  final Function validator;
  final String hintText;
  final bool obscureText;
  final TextInputType textInputType;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: kWhiteColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kWhiteColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBackgroundBaseColor, width: 2),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: textInputType ?? TextInputType.text,
      initialValue: initialValue ?? null,
    );
  }
}

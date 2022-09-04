import 'package:flutter/material.dart';

class DetailText extends StatelessWidget {
  final String text;
  const DetailText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18),
    );
  }
}

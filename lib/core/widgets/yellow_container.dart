import 'package:cineroye/theme/palette.dart';
import 'package:flutter/material.dart';

class YellowContainer extends StatelessWidget {
  final String text;
  final double? padding;
  final double? weight;
  final double? width;
  final double? fontSize;

  const YellowContainer(
      {Key? key,
      this.fontSize,
      this.width,
      this.weight,
      required this.text,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: weight ?? 25,
      width: width ?? 70,
      decoration: BoxDecoration(
          color: yellowColor, borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.all(padding ?? 4.0),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(fontSize: fontSize ?? 14),
          ),
        ),
      ),
    );
  }
}

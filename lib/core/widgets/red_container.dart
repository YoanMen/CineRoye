import 'package:flutter/material.dart';

class RedContainer extends StatelessWidget {
  final String text;
  final double? padding;

  const RedContainer({Key? key, required this.text, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.all(padding ?? 4.0),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

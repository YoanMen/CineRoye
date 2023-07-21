import 'package:cineroye/theme/palette.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    super.key,
    required this.error,
    required this.onRefresh,
  });

  final Future<void> Function() onRefresh;
  final Object error;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: blackColor,
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
          child: Center(
            child: Text(
              '$error',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: greyColor.withOpacity(0.62)),
            ),
          ),
        ),
      ),
    );
  }
}

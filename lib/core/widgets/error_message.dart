import 'package:cineroye/core/constant.dart';
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
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kmediumSpace),
              child: Text(
                '$error',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: greyColor.withOpacity(0.62)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

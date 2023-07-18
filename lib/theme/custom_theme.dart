import 'package:cineroye/theme/palette.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData darkTheme(BuildContext context) {
    final theme = Theme.of(context);
    return ThemeData(
        colorScheme: colorSchemeDark,
        scaffoldBackgroundColor: blackColor,
        textTheme: theme.textTheme
            .apply(bodyColor: whiteColor, displayColor: whiteColor),
        appBarTheme: const AppBarTheme(
            elevation: 0, backgroundColor: Colors.transparent));
  }
}

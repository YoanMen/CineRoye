import 'package:cineroye/features/movie_showing/movie_showing_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieShowing extends ConsumerWidget {
  const MovieShowing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationBar =
        ref.read(movieShowingControllerProvider.notifier).navigationMenu();
    final indexPage = ref.watch(movieShowingControllerProvider).indexPage;
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          ref.read(movieShowingControllerProvider).page[indexPage],
          Align(alignment: Alignment.bottomCenter, child: navigationBar)
        ],
      ),
    );
  }
}

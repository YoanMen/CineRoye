import 'package:cineroye/core/constant.dart';
import 'package:cineroye/core/widgets/red_container.dart';
import 'package:cineroye/features/movie_showing/movie_showing_controller.dart';
import 'package:cineroye/features/movie_showing/onDisplay/movie_list.dart';
import 'package:cineroye/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComingSoonScreen extends ConsumerWidget {
  const ComingSoonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isPhone = MediaQuery.of(context).size.width < 512;

    final theme = Theme.of(context);
    final moviesData = ref.watch(movieShowingControllerProvider).moviesSoon;

    return moviesData.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Erreur : $error"),
            const SizedBox(
              height: kmediumSpace,
            ),
            InkWell(
                onTap: ref
                    .read(movieShowingControllerProvider.notifier)
                    .fetchComingSoon,
                child: const RedContainer(text: 'Rafraichir la page'))
          ],
        ),
      ),
      data: (data) {
        return Scaffold(
            body: RefreshIndicator(
          backgroundColor: blackColor,
          onRefresh:
              ref.read(movieShowingControllerProvider.notifier).fetchComingSoon,
          child: isPhone
              ? Column(
                  children: [
                    const SizedBox(
                      height: kmediumSpace,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) =>
                            MovieList(movie: data[index], theme: theme),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: kmediumSpace,
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 200, crossAxisCount: 2),
                        itemCount: data.length,
                        itemBuilder: (context, index) => MovieList(
                          movie: data[index],
                          theme: theme,
                        ),
                      ),
                    ),
                  ],
                ),
        ));
      },
    );
  }
}

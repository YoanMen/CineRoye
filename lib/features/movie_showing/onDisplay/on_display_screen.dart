import 'package:cineroye/core/constant.dart';
import 'package:cineroye/core/widgets/red_container.dart';
import 'package:cineroye/features/movie_showing/carousel/carousel_slider.dart';
import 'package:cineroye/features/movie_showing/movie_showing_controller.dart';
import 'package:cineroye/features/movie_showing/onDisplay/movie_list.dart';
import 'package:cineroye/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayScreen extends ConsumerWidget {
  const DisplayScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isPhone = MediaQuery.of(context).size.width < 512;
    final theme = Theme.of(context);
    final moviesData = ref.watch(movieShowingControllerProvider).movies;

    return moviesData.when(
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erreur : $error'),
                  const SizedBox(
                    height: kmediumSpace,
                  ),
                  InkWell(
                      onTap: ref
                          .read(movieShowingControllerProvider.notifier)
                          .fetchMovies,
                      child: const RedContainer(text: 'Rafraichir la page'))
                ],
              ),
            ),
        data: (data) {
          return Scaffold(
              body: RefreshIndicator(
            backgroundColor: blackColor,
            onRefresh:
                ref.read(movieShowingControllerProvider.notifier).fetchMovies,
            child: isPhone
                ? SingleChildScrollView(
                    primary: true,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: kmediumSpace,
                        ),
                        Carousel(movies: data),
                        const SizedBox(
                          height: kmediumSpace,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) =>
                              MovieList(movie: data[index], theme: theme),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: kmediumSpace,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Center(child: Carousel(movies: data)),
                        ),
                        const SizedBox(
                          width: kmediumSpace,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(top: kmediumSpace),
                            child: MovieList(movie: data[index], theme: theme),
                          ),
                        ),
                      ],
                    ),
                  ),
          ));
        });
  }
}

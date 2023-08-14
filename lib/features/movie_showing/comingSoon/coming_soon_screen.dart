import 'package:cineroye/core/constant.dart';
import 'package:cineroye/core/widgets/error_message.dart';
import 'package:cineroye/features/movie_showing/movie_showing_controller.dart';
import 'package:cineroye/features/movie_showing/onDisplay/movie_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/palette.dart';

class ComingSoonScreen extends ConsumerWidget {
  const ComingSoonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final moviesData = ref.watch(movieShowingControllerProvider).moviesSoon;

    return moviesData.when(
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (error, stackTrace) => ErrorMessage(
            onRefresh: ref
                .read(movieShowingControllerProvider.notifier)
                .fetchComingSoon,
            error: error),
        data: (data) {
          return data.isEmpty
              ? ErrorMessage(
                  onRefresh: ref
                      .read(movieShowingControllerProvider.notifier)
                      .fetchMovies,
                  error: "Aucun films en projection",
                )
              : Scaffold(
                  body: SafeArea(
                  child: RefreshIndicator(
                      backgroundColor: blackColor,
                      onRefresh: ref
                          .read(movieShowingControllerProvider.notifier)
                          .fetchComingSoon,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: kmediumSpace,
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) =>
                                  MovieListAnimation(
                                      movie: data[index], theme: theme),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).padding.top + 20,
                            ),
                          ],
                        ),
                      )),
                ));
        });
  }
}

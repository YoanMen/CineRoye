import 'package:cineroye/core/constant.dart';
import 'package:cineroye/core/widgets/error_message.dart';
import 'package:cineroye/features/movie_showing/movie_showing_controller.dart';
import 'package:cineroye/features/movie_showing/onDisplay/movie_list.dart';
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
      error: (error, stackTrace) => ErrorMessage(
          onRefresh:
              ref.read(movieShowingControllerProvider.notifier).fetchComingSoon,
          error: error),
      data: (data) {
        return data.isEmpty
            ? ErrorMessage(
                onRefresh: ref
                    .read(movieShowingControllerProvider.notifier)
                    .fetchComingSoon,
                error: "Aucun film n'est programmé pour le moment",
              )
            : Scaffold(
                body: SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: kmediumSpace,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.top,
                        ),
                        Expanded(
                          child: isPhone
                              ? ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) =>
                                      MovieListAnimation(
                                          movie: data[index], theme: theme),
                                )
                              : GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: 200,
                                          crossAxisCount: 2),
                                  itemCount: data.length,
                                  itemBuilder: (context, index) =>
                                      MovieListAnimation(
                                    movie: data[index],
                                    theme: theme,
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.top + 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}

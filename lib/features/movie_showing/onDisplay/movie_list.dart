import 'package:cineroye/core/constant.dart';
import 'package:cineroye/core/widgets/red_container.dart';
import 'package:cineroye/core/widgets/yellow_container.dart';
import 'package:cineroye/features/movie_showing/movie_showing_controller.dart';
import 'package:cineroye/features/movie_showing/onDisplay/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/palette.dart';

class MovieList extends ConsumerWidget {
  const MovieList({
    super.key,
    required this.movie,
    required this.theme,
  });

  final Movie movie;
  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref
          .read(movieShowingControllerProvider.notifier)
          .detailedMovie(context, movie),
      child: SizedBox(
        height: 200,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: kmediumSpace),
              child: SizedBox(
                height: 160,
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    movie.poster,
                    fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      "${movie.duration}min",
                      style: theme.textTheme.titleSmall!
                          .copyWith(color: greyColor),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    SizedBox(
                      height: 25,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: movie.genres.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child:
                              RedContainer(text: movie.genres[index] as String),
                        ),
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    const SizedBox(
                      height: kmediumSpace / 2,
                    ),
                    Text(
                      movie.overview,
                      style: theme.textTheme.bodyMedium,
                      maxLines: (movie.firstProjection != null) ? 3 : 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: kmediumSpace / 2),
                    SizedBox(
                        height: 25,
                        width: 180,
                        child: movie.firstProjection != null
                            ? YellowContainer(
                                text: movie.firstProjection!,
                              )
                            : null),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

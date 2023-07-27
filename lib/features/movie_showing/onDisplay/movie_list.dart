import 'package:cineroye/core/constant.dart';
import 'package:cineroye/core/widgets/red_container.dart';
import 'package:cineroye/core/widgets/yellow_container.dart';
import 'package:cineroye/features/movie_showing/movie_showing_controller.dart';
import 'package:cineroye/features/movie_showing/onDisplay/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kmediumSpace),
      child: GestureDetector(
        onTap: () => ref
            .read(movieShowingControllerProvider.notifier)
            .detailedMovie(context, movie),
        child: Container(
          padding: const EdgeInsets.only(left: kmediumSpace),
          height: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 160,
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: movie.poster,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${movie.duration}min",
                        style: theme.textTheme.titleSmall!
                            .copyWith(color: greyColor.withOpacity(0.6)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: kmediumSpace),
                        child: Text(
                          movie.title.toUpperCase(),
                          style: theme.textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 25,
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: movie.genres.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: RedContainer(
                                text: movie.genres[index] as String),
                          ),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                        ),
                      ),
                      const SizedBox(
                        height: kmediumSpace,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: kmediumSpace),
                        child: Text(
                          movie.overview,
                          textScaleFactor: 1,
                          style: theme.textTheme.bodyMedium,
                          maxLines: (movie.firstProjection != null) ? 3 : 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      if (movie.firstProjection != null)
                        SizedBox(
                            height: 25,
                            width: 150,
                            child: YellowContainer(
                              text: movie.firstProjection!,
                            )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

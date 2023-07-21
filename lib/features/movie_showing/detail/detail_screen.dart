import 'package:cineroye/core/constant.dart';
import 'package:cineroye/core/widgets/red_container.dart';
import 'package:cineroye/features/movie_showing/onDisplay/movie.dart';
import 'package:cineroye/features/movie_showing/movie_showing_controller.dart';
import 'package:cineroye/features/movie_showing/projectionDay/projection_day_card.dart';
import 'package:cineroye/features/movie_showing/video/video_screen.dart';
import 'package:cineroye/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({Key? key, required this.movie}) : super(key: key);

  final Movie movie;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(movieShowingControllerProvider).selectableDays;
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [blackColor.withOpacity(0.62), Colors.transparent],
          )),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: ListView(
              padding: const EdgeInsets.only(top: 0),
              children: [
                PosterImage(movie: movie, theme: theme),
                const SizedBox(
                  height: kmediumSpace,
                ),
                GenreContainers(movie: movie),
                ProjectionTimeCard(
                  movie: movie,
                  theme: theme,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kmediumSpace),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                        height: 30,
                        child: ref
                            .read(movieShowingControllerProvider.notifier)
                            .showScheduleForDaySelected(movie)),
                  ),
                ),
                DetaillingMovie(movie: movie, theme: theme),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class DetaillingMovie extends StatelessWidget {
  const DetaillingMovie({
    super.key,
    required this.movie,
    required this.theme,
  });

  final Movie movie;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(kmediumSpace),
          child: Text(
            movie.overview,
            style: theme.textTheme.titleMedium,
          ),
        ),

        //* Realisator
        if (movie.realisator != null)
          Padding(
            padding: const EdgeInsets.all(kmediumSpace),
            child: Text(
              "Réalisé par ${movie.realisator}",
              style: theme.textTheme.titleMedium,
            ),
          ),

        //* Actors
        if (movie.actors != null)
          Padding(
            padding: const EdgeInsets.all(kmediumSpace),
            child: Text(
              "Avec ${movie.actors}",
              style: theme.textTheme.titleMedium,
            ),
          ),
      ],
    );
  }
}

class GenreContainers extends StatelessWidget {
  const GenreContainers({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width: double.infinity,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: kmediumSpace),
        itemCount: movie.genres.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 4),
          child: RedContainer(text: movie.genres[index] as String),
        ),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class PosterImage extends StatelessWidget {
  const PosterImage({
    super.key,
    required this.movie,
    required this.theme,
  });

  final Movie movie;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height / 2),
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Colors.transparent
                  ]).createShader(
                  Rect.fromLTRB(0, 0, bounds.width, bounds.height));
            },
            blendMode: BlendMode.dstIn,
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              child: Image.network(
                movie.poster,
                fit: BoxFit.fitWidth,
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
        Positioned(
          bottom: 0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(kmediumSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " ${movie.duration}min",
                    style: theme.textTheme.titleSmall!
                        .copyWith(color: greyColor.withOpacity(0.6)),
                  ),
                  const SizedBox(
                    height: kmediumSpace,
                  ),
                  Text(
                    movie.title,
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (movie.video != null)
          SizedBox(
            height: 128,
            width: 128,
            child: IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoScreen(movie: movie),
                  )),
              icon: Icon(
                Icons.play_circle_fill_rounded,
                color: yellowColor.withOpacity(0.8),
                size: 80,
              ),
            ),
          ),
      ],
    );
  }
}

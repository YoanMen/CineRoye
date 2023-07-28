import 'package:cineroye/core/constant.dart';
import 'package:cineroye/core/widgets/red_container.dart';
import 'package:cineroye/features/movie_showing/onDisplay/movie.dart';
import 'package:cineroye/features/movie_showing/movie_showing_controller.dart';
import 'package:cineroye/features/movie_showing/projectionDay/projection_day_card.dart';
import 'package:cineroye/features/movie_showing/video/video_screen.dart';
import 'package:cineroye/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailScreenAnimation extends StatefulWidget {
  const DetailScreenAnimation({Key? key, required this.movie})
      : super(key: key);
  final Movie movie;
  @override
  State<DetailScreenAnimation> createState() => _DetailScreenAnimationState();
}

class _DetailScreenAnimationState extends State<DetailScreenAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _scheduleController;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _scheduleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 240));

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _scheduleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetailScreen(
        movie: widget.movie,
        animationController: _controller,
        animationSchedulesController: _scheduleController);
  }
}

class DetailScreen extends ConsumerWidget {
  DetailScreen(
      {Key? key,
      required this.movie,
      required this.animationController,
      required this.animationSchedulesController})
      : posterOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController, curve: const Interval(0.2, 0.8))),
        titleOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController, curve: const Interval(0.2, 0.4))),
        genreOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController, curve: const Interval(0.4, 0.6))),
        dateOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController, curve: const Interval(0.6, 0.8))),
        textOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController, curve: const Interval(0.8, 1.0))),
        iconVideoOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController, curve: const Interval(0.8, 1.0))),
        scheduleOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationSchedulesController,
            curve: const Interval(0.0, 1.0))),
        super(key: key);

  final Movie movie;
  final AnimationController animationController;
  final AnimationController animationSchedulesController;

  final Animation<double> posterOpacity;
  final Animation<double> titleOpacity;
  final Animation<double> genreOpacity;
  final Animation<double> dateOpacity;
  final Animation<double> textOpacity;
  final Animation<double> iconVideoOpacity;
  final Animation<double> scheduleOpacity;

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
                PosterImage(
                    movie: movie,
                    theme: theme,
                    posterOpacity: posterOpacity,
                    titleOpacity: titleOpacity,
                    iconVideoOpacity: iconVideoOpacity),
                const SizedBox(
                  height: kmediumSpace,
                ),
                FadeTransition(
                    opacity: genreOpacity,
                    child: GenreContainers(movie: movie)),
                FadeTransition(
                  opacity: dateOpacity,
                  child: ProjectionTimeCard(
                    movie: movie,
                    theme: theme,
                    animationSchedulesController: animationSchedulesController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kmediumSpace),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                        height: 30,
                        child: ref
                            .read(movieShowingControllerProvider.notifier)
                            .showScheduleForDaySelected(
                                movie, scheduleOpacity)),
                  ),
                ),
                FadeTransition(
                    opacity: textOpacity,
                    child: DetaillingMovie(movie: movie, theme: theme)),
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
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
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
    required this.posterOpacity,
    required this.titleOpacity,
    required this.iconVideoOpacity,
  });

  final Animation<double> posterOpacity;
  final Animation<double> titleOpacity;
  final Animation<double> iconVideoOpacity;
  final Movie movie;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Colors.transparent
                ])
                .createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
          },
          blendMode: BlendMode.dstIn,
          child: FadeTransition(
            opacity: posterOpacity,
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2.5,
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: movie.poster,
                fit: BoxFit.fitWidth,
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
              child: FadeTransition(
                opacity: titleOpacity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${movie.duration}min",
                      style: theme.textTheme.titleMedium!
                          .copyWith(color: greyColor.withOpacity(0.6)),
                    ),
                    Text(
                      movie.title.toUpperCase(),
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (movie.video != null)
          FadeTransition(
            opacity: iconVideoOpacity,
            child: SizedBox(
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
                  color: yellowColor.withOpacity(0.62),
                  size: 80,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

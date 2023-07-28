import 'package:cineroye/core/constant.dart';
import 'package:cineroye/core/widgets/red_container.dart';
import 'package:cineroye/core/widgets/yellow_container.dart';
import 'package:cineroye/features/movie_showing/movie_showing_controller.dart';
import 'package:cineroye/features/movie_showing/onDisplay/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../theme/palette.dart';

class MovieListAnimation extends StatefulWidget {
  const MovieListAnimation({Key? key, required this.movie, required this.theme})
      : super(key: key);

  final Movie movie;
  final ThemeData theme;

  @override
  State<MovieListAnimation> createState() => _MovieListAnimationState();
}

class _MovieListAnimationState extends State<MovieListAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MovieList(
        movie: widget.movie,
        theme: widget.theme,
        animationController: _controller);
  }
}

class MovieList extends ConsumerWidget {
  MovieList(
      {super.key,
      required this.movie,
      required this.theme,
      required this.animationController})
      : posterOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController, curve: const Interval(0.0, 0.2))),
        titleOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController, curve: const Interval(0.2, 0.4))),
        genreOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController, curve: const Interval(0.4, 0.6))),
        dateOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController, curve: const Interval(0.8, 1.0))),
        textOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController, curve: const Interval(0.6, 0.8)));

  final Movie movie;
  final ThemeData theme;

  final AnimationController animationController;

  final Animation<double> posterOpacity;
  final Animation<double> titleOpacity;
  final Animation<double> genreOpacity;
  final Animation<double> dateOpacity;
  final Animation<double> textOpacity;

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
                  child: FadeTransition(
                    opacity: posterOpacity,
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: movie.poster,
                      fit: BoxFit.fitHeight,
                    ),
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
                      FadeTransition(
                        opacity: titleOpacity,
                        child: Text(
                          "${movie.duration}min",
                          style: theme.textTheme.titleSmall!
                              .copyWith(color: greyColor.withOpacity(0.6)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: kmediumSpace),
                        child: FadeTransition(
                          opacity: titleOpacity,
                          child: Text(
                            movie.title.toUpperCase(),
                            style: theme.textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
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
                            child: FadeTransition(
                              opacity: genreOpacity,
                              child: RedContainer(
                                  text: movie.genres[index] as String),
                            ),
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
                        child: FadeTransition(
                          opacity: textOpacity,
                          child: Text(
                            movie.overview,
                            textScaleFactor: 1,
                            style: theme.textTheme.bodyMedium,
                            maxLines: (movie.firstProjection != null) ? 3 : 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (movie.firstProjection != null)
                        SizedBox(
                            height: 25,
                            width: 150,
                            child: FadeTransition(
                              opacity: dateOpacity,
                              child: YellowContainer(
                                text: movie.firstProjection!,
                              ),
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

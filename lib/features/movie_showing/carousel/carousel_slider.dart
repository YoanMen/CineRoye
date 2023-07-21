import 'package:carousel_slider/carousel_slider.dart';
import 'package:cineroye/features/movie_showing/movie_showing_controller.dart';
import 'package:cineroye/features/movie_showing/onDisplay/movie.dart';
import 'package:cineroye/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Carousel extends ConsumerWidget {
  Carousel({super.key, required this.movies});

  final List<Movie> movies;

  final CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isPhone = MediaQuery.of(context).size.width < 512;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CarouselSlider.builder(
          itemCount: movies.length,
          itemBuilder: (context, index, realIndex) =>
              CarouselImage(movie: movies[index], theme: Theme.of(context)),
          carouselController: buttonCarouselController,
          options: CarouselOptions(
            enlargeCenterPage: true,
            height: isPhone
                ? MediaQuery.of(context).size.height / 2
                : MediaQuery.of(context).size.height - 200,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 8),
            autoPlayAnimationDuration: const Duration(seconds: 2),
            viewportFraction: 1,
            initialPage: ref.watch(movieShowingControllerProvider).sliderIndex,
            onPageChanged: (index, reason) => ref
                .read(movieShowingControllerProvider.notifier)
                .changeSliderIndex(index),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.12)),
            child: AnimatedSmoothIndicator(
                effect: WormEffect(
                    type: WormType.normal,
                    dotHeight: 14,
                    dotWidth: 14,
                    activeDotColor: Theme.of(context).colorScheme.primary,
                    dotColor: greyColor.withOpacity(0.15)),
                activeIndex:
                    ref.watch(movieShowingControllerProvider).sliderIndex,
                count: movies.length),
          ),
        )
      ],
    );
  }
}

class CarouselImage extends ConsumerWidget {
  const CarouselImage({
    super.key,
    required this.movie,
    required this.theme,
  });

  final Movie movie;
  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () => ref
              .read(movieShowingControllerProvider.notifier)
              .detailedMovie(context, movie),
          child: Container(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height / 2),
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
                child: Image.network(fit: BoxFit.fitHeight, movie.poster),
              ),
            ),
          ),
        ),
        // Positioned(
        //     bottom: 0,
        //     child: SizedBox(
        //       width: MediaQuery.of(context).size.width,
        //       child: Padding(
        //         padding: const EdgeInsets.all(kmediumSpace),
        //         child: Text(
        //           movie.title,
        //           style: theme.textTheme.headlineSmall,
        //         ),
        //       ),
        //     )),
      ],
    );
  }
}

import 'package:cineroye/core/constant.dart';
import 'package:cineroye/features/movie_showing/onDisplay/movie.dart';
import 'package:cineroye/features/movie_showing/movie_showing_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectionTimeCard extends ConsumerWidget {
  const ProjectionTimeCard({
    super.key,
    required this.movie,
    required this.theme,
    required this.animationSchedulesController,
  });

  final Movie movie;
  final ThemeData theme;
  final AnimationController animationSchedulesController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(kmediumSpace),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final day in movie.days)
              Padding(
                padding: const EdgeInsets.only(right: kmediumSpace),
                child: InkWell(
                  onTap: () async {
                    if (!ref
                        .read(movieShowingControllerProvider.notifier)
                        .canSelectDay(
                          movie,
                          movie.days.indexOf(day),
                        )) {
                      if (animationSchedulesController.value != 0) {
                        animationSchedulesController.reverse();

                        await Future.delayed(
                            animationSchedulesController.duration!);
                        animationSchedulesController.forward();
                      } else {
                        animationSchedulesController.forward();
                      }
                      ref
                          .read(movieShowingControllerProvider.notifier)
                          .selectADay(
                            movie,
                            movie.days.indexOf(day),
                          );
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 70,
                      width: 50,
                      decoration: BoxDecoration(
                          color: ref
                              .watch(movieShowingControllerProvider)
                              .selectableDays[movie.days.indexOf(day)]
                              .currentColor),
                      child: Center(
                          child: Text(
                        (day == "Aujourd'hui")
                            ? "Auj.\n ${DateTime.now().day}"
                            : day.replaceAll(".", ".\n"),
                        style: theme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

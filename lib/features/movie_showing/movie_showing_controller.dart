import 'dart:ui';

import 'package:cineroye/core/constant.dart';
import 'package:cineroye/core/widgets/yellow_container.dart';
import 'package:cineroye/features/movie_showing/comingSoon/coming_soon_screen.dart';
import 'package:cineroye/features/movie_showing/detail/detail_screen.dart';
import 'package:cineroye/features/movie_showing/onDisplay/movie.dart';
import 'package:cineroye/features/movie_showing/movie_showing_service.dart';
import 'package:cineroye/features/movie_showing/movie_showing_state.dart';
import 'package:cineroye/features/movie_showing/onDisplay/on_display_screen.dart';
import 'package:cineroye/features/movie_showing/projectionDay/projection_day.dart';
import 'package:cineroye/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieShowingControllerProvider = StateNotifierProvider.autoDispose<
    MovieShowingController, MovieShowingState>((ref) {
  final movieFlowService = ref.watch(movieFlowServiceProvider);
  return MovieShowingController(
      const MovieShowingState(
          movies: AsyncValue.data([]),
          moviesSoon: AsyncValue.data([]),
          selectableDays: [],
          indexPage: 0,
          sliderIndex: 0,
          page: [DisplayScreen(), ComingSoonScreen()]),
      movieFlowService);
});

class MovieShowingController extends StateNotifier<MovieShowingState> {
  MovieShowingController(MovieShowingState state, this._movieService)
      : super(state) {
    fetchMovies();
    fetchComingSoon();
  }
  final MovieShowingService _movieService;

  //* call service to get movies data

  Future<void> fetchMovies() async {
    state = state.copyWith(
      movies: const AsyncValue.loading(),
    );
    final result = await _movieService.fetchMovies();

    result.when((movies) {
      state = state.copyWith(movies: AsyncValue.data(movies));
    }, (error) {
      state =
          state.copyWith(movies: AsyncValue.error(error, StackTrace.current));
    });
  }

  Future<void> fetchComingSoon() async {
    state = state.copyWith(
      moviesSoon: const AsyncValue.loading(),
    );
    final result = await _movieService.fetchMoviesSoon();

    result.when((movies) {
      state = state.copyWith(moviesSoon: AsyncValue.data(movies));
    }, (error) {
      state = state.copyWith(
          moviesSoon: AsyncValue.error(error, StackTrace.current));
    });
  }

  void switchPage(int pageIndex) {
    state = state.copyWith(indexPage: pageIndex);
  }

  Widget navigationMenu() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: BottomNavigationBar(
          unselectedLabelStyle: TextStyle(color: whiteColor, fontSize: 14),
          unselectedItemColor: greyColor,
          backgroundColor: blackColor.withOpacity(0.62),
          currentIndex: state.indexPage,
          onTap: (value) => switchPage(value),
          items: [
            BottomNavigationBarItem(
                label: "A l'affiche",
                icon: Icon(
                  Icons.theaters,
                  color: greyColor,
                )),
            BottomNavigationBarItem(
                label: "Prochainement",
                icon: Icon(
                  Icons.event,
                  color: greyColor,
                ))
          ],
        ),
      ),
    );
  }
  //* setting a color of selectable day in detailed page

  void setColorDaySelectable(Movie movie) {
    List<ProjectionDay> projectionDays = [];

    for (var schedule in movie.schedules) {
      if (schedule.isEmpty) {
        ProjectionDay projectionDay = ProjectionDay.initial();
        projectionDays.add(projectionDay);
      } else {
        ProjectionDay projectionDay = ProjectionDay(
            selected: false, currentColor: yellowColor.withOpacity(0.45));
        projectionDays.add(projectionDay);
      }
    }

    state = state.copyWith(selectableDays: projectionDays);
  }

  // * When day is selected display schedule to user

  Row? showScheduleForDaySelected(
      Movie movie, Animation<double> scheduleOpacity) {
    int daySelected =
        state.selectableDays.indexWhere((element) => element.selected == true);

    if (daySelected != -1) {
      final schedules = movie.schedules[daySelected];
      return Row(
        children: [
          for (var schedule in schedules)
            Padding(
              padding: const EdgeInsets.only(right: kmediumSpace),
              child: FadeTransition(
                opacity: scheduleOpacity,
                child: YellowContainer(
                  text: schedule,
                  fontSize: 18,
                  weight: 30,
                  width: 100,
                ),
              ),
            ),
        ],
      );
    }
    return null;
  }

  void changeSliderIndex(int index) {
    state = state.copyWith(sliderIndex: index);
  }

  //* when user select a selectable date

  void selectADay(Movie movie, int index) {
    if (movie.schedules[index] == null) return;

    List<ProjectionDay> projectionDays =
        createProjectionDays(movie.schedules, index);

    state = state.copyWith(selectableDays: projectionDays);
  }

  List<ProjectionDay> createProjectionDays(
      List<dynamic> schedules, int selectedIndex) {
    return schedules.map((schedule) {
      if (schedule != null && schedule is List<String> && schedule.isNotEmpty) {
        final index = schedules.indexOf(schedule);
        if (index == selectedIndex) {
          return ProjectionDay(selected: true, currentColor: yellowColor);
        }
        return ProjectionDay(
            selected: false, currentColor: yellowColor.withOpacity(0.45));
      }
      return ProjectionDay.initial();
    }).toList();
  }

  void detailedMovie(BuildContext context, Movie movie) {
    setColorDaySelectable(movie);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreenAnimation(movie: movie),
      ),
    );
  }
}

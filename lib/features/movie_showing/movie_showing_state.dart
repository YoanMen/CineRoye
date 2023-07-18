// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cineroye/features/movie_showing/onDisplay/movie.dart';
import 'package:cineroye/features/movie_showing/projectionDay/projection_day.dart';

@immutable
class MovieShowingState {
  final AsyncValue<List<Movie>> movies;
  final AsyncValue<List<Movie>> moviesSoon;

  final List<ProjectionDay> selectableDays;
  final int indexPage;
  final List<Widget> page;
  final int sliderIndex;
  const MovieShowingState(
      {required this.movies,
      required this.moviesSoon,
      required this.selectableDays,
      required this.page,
      required this.indexPage,
      required this.sliderIndex});

  @override
  String toString() =>
      'MovieShowingState(movies: $movies, selectableDays: $selectableDays)';

  MovieShowingState copyWith({
    AsyncValue<List<Movie>>? movies,
    AsyncValue<List<Movie>>? moviesSoon,
    List<ProjectionDay>? selectableDays,
    int? indexPage,
    List<Widget>? page,
    int? sliderIndex,
  }) {
    return MovieShowingState(
        movies: movies ?? this.movies,
        moviesSoon: moviesSoon ?? this.moviesSoon,
        selectableDays: selectableDays ?? this.selectableDays,
        indexPage: indexPage ?? this.indexPage,
        page: page ?? this.page,
        sliderIndex: sliderIndex ?? this.sliderIndex);
  }

  @override
  bool operator ==(covariant MovieShowingState other) {
    if (identical(this, other)) return true;

    return other.movies == movies && other.selectableDays == selectableDays;
  }

  @override
  int get hashCode => movies.hashCode ^ selectableDays.hashCode;
}

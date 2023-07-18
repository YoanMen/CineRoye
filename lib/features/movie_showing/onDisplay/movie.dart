// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

import 'package:cineroye/features/movie_showing/onDisplay/movie_entity.dart';

@immutable
class Movie {
  final String title;
  final String poster;
  final List<String> days;
  final String? video;
  final String overview;
  final String duration;
  final String? actors;
  final String? realisator;
  final List<String?> genres;
  final List<dynamic> schedules;
  final String? firstProjection;
  const Movie({
    required this.title,
    this.actors,
    this.realisator,
    this.firstProjection,
    this.video,
    required this.days,
    required this.poster,
    required this.overview,
    required this.duration,
    required this.genres,
    required this.schedules,
  });

  factory Movie.fromEntity(MovieEntity entity) {
    return Movie(
        title: entity.title,
        poster: entity.poster,
        days: entity.days,
        overview: entity.overview,
        duration: entity.duration,
        realisator: entity.realisator,
        genres: entity.genre,
        firstProjection: entity.firstProjection,
        video: entity.video,
        schedules: entity.schedules);
  }

  @override
  String toString() {
    return 'Movie(title: $title, poster: $poster, overview: $overview, duration: $duration, actors: $actors, realisator: $realisator, genres: $genres, schedules: $schedules)';
  }

  @override
  bool operator ==(covariant Movie other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.poster == poster &&
        other.overview == overview &&
        other.duration == duration &&
        other.actors == actors &&
        other.realisator == realisator &&
        other.genres == genres &&
        listEquals(other.schedules, schedules);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        poster.hashCode ^
        overview.hashCode ^
        duration.hashCode ^
        actors.hashCode ^
        realisator.hashCode ^
        genres.hashCode ^
        schedules.hashCode;
  }
}

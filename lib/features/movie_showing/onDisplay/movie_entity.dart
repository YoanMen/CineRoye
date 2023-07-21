import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MovieEntity {
  final String title;
  final String overview;
  final String? video;
  final List<String> days;
  final String realisator;
  final String poster;
  final List<String?> genre;
  final String? firstProjection;
  final List<dynamic> schedules;
  final String duration;

  const MovieEntity({
    this.video,
    required this.realisator,
    required this.days,
    required this.firstProjection,
    required this.schedules,
    required this.title,
    required this.overview,
    required this.poster,
    required this.genre,
    required this.duration,
  });

  factory MovieEntity.fromMap(Map<String, dynamic> map) {
    return MovieEntity(
        title: map["title"],
        overview: map["overview"],
        poster: map["poster"],
        days: map["days"],
        genre: map['genres'],
        duration: map['duration'],
        schedules: map["schedules"],
        firstProjection: map["firstProjection"],
        video: map["video"],
        realisator: map['realisators']);
  }

  @override
  String toString() {
    return 'MovieEntity(title: $title, overview: $overview, realisator: $realisator, poster: $poster, genre: $genre, schedules: $schedules, duration: $duration)';
  }

  @override
  bool operator ==(covariant MovieEntity other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.overview == overview &&
        other.realisator == realisator &&
        other.poster == poster &&
        other.genre == genre &&
        listEquals(other.schedules, schedules) &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        overview.hashCode ^
        realisator.hashCode ^
        poster.hashCode ^
        genre.hashCode ^
        schedules.hashCode ^
        duration.hashCode;
  }
}

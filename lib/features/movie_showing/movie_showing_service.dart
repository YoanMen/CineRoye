import 'package:cineroye/core/failure.dart';
import 'package:cineroye/features/movie_showing/movie_showing_repository.dart';
import 'package:cineroye/features/movie_showing/onDisplay/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';

final movieFlowServiceProvider = Provider<MovieShowingService>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider);

  return ScrapMovieService(movieRepository);
});

abstract class MovieShowingService {
  Future<Result<List<Movie>, Failure>> fetchMovies();
  Future<Result<List<Movie>, Failure>> fetchMoviesSoon();
}

class ScrapMovieService implements MovieShowingService {
  ScrapMovieService(this.movieRepository);
  final MovieRepository movieRepository;

  @override
  Future<Result<List<Movie>, Failure>> fetchMovies() async {
    try {
      final movieEntities = await movieRepository.fetchMovies();
      final movies = movieEntities.map((e) => Movie.fromEntity(e)).toList();
      return Success(movies);
    } on Failure catch (failure) {
      return Error(failure);
    }
  }

  @override
  Future<Result<List<Movie>, Failure>> fetchMoviesSoon() async {
    try {
      final movieEntities = await movieRepository.fetchComingMovies();
      final movies = movieEntities.map((e) => Movie.fromEntity(e)).toList();
      return Success(movies);
    } on Failure catch (failure) {
      return Error(failure);
    }
  }
}

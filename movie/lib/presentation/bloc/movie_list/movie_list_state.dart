part of 'movie_list_bloc.dart';

sealed class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object?> get props => [];
}

final class MovieListInitial extends MovieListState {}

final class MovieListLoading extends MovieListState {}

final class MovieListHasError extends MovieListState {
  final String message;

  MovieListHasError(this.message);

  @override
  List<Object?> get props => [message];
}

final class MovieListHasData extends MovieListState {
  final List<Movie> nowPlayingResult;
  final List<Movie> popularResult;
  final List<Movie> topRatedResult;

  MovieListHasData(
    this.nowPlayingResult,
    this.popularResult,
    this.topRatedResult,
  );

  @override
  List<Object?> get props => [nowPlayingResult, popularResult, topRatedResult];
}

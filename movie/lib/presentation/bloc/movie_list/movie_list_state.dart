part of 'movie_list_bloc.dart';

sealed class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object?> get props => [];
}

final class MovieListInitial extends MovieListState {}

final class MovieListLoading extends MovieListState {}

final class MovieListEmpty extends MovieListState {
  final String message;

  MovieListEmpty(this.message);

  @override
  List<Object?> get props => [message];
}

final class MovieListHasError extends MovieListState {
  final String message;

  MovieListHasError(this.message);

  @override
  List<Object?> get props => [message];
}

final class MovieListHasData extends MovieListState {
  final List<Movie> result;

  MovieListHasData(this.result);

  @override
  List<Object?> get props => [result];
}

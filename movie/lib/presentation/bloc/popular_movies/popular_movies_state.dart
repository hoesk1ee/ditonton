part of 'popular_movies_bloc.dart';

sealed class PopularMoviesState extends Equatable {
  const PopularMoviesState();

  @override
  List<Object?> get props => [];
}

final class PopularMoviesInitial extends PopularMoviesState {}

final class PopularMoviesEmpty extends PopularMoviesState {
  final String message;

  const PopularMoviesEmpty(this.message);

  @override
  List<Object?> get props => [message];
}

final class PopularMoviesLoading extends PopularMoviesState {}

final class PopularMoviesHasError extends PopularMoviesState {
  final String message;

  const PopularMoviesHasError(this.message);

  @override
  List<Object?> get props => [message];
}

final class PopularMoviesHasData extends PopularMoviesState {
  final List<Movie> result;

  const PopularMoviesHasData(this.result);

  @override
  List<Object?> get props => [result];
}

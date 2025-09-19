part of 'top_rated_movies_bloc.dart';

sealed class TopRatedMoviesState extends Equatable {
  const TopRatedMoviesState();

  @override
  List<Object?> get props => [];
}

final class TopRatedMoviesInitial extends TopRatedMoviesState {}

final class TopRatedMoviesLoading extends TopRatedMoviesState {}

final class TopRatedMoviesEmpty extends TopRatedMoviesState {
  final String message;

  const TopRatedMoviesEmpty(this.message);

  @override
  List<Object?> get props => [message];
}

final class TopRatedMoviesHasError extends TopRatedMoviesState {
  final String message;

  const TopRatedMoviesHasError(this.message);

  @override
  List<Object?> get props => [message];
}

final class TopRatedMoviesHasData extends TopRatedMoviesState {
  final List<Movie> result;

  const TopRatedMoviesHasData(this.result);

  @override
  List<Object?> get props => [result];
}

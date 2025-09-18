part of 'watchlist_movies_bloc.dart';

sealed class WatchlistMoviesState extends Equatable {
  const WatchlistMoviesState();

  @override
  List<Object?> get props => [];
}

final class WatchlistMoviesInitial extends WatchlistMoviesState {}

final class WatchlistMoviesLoading extends WatchlistMoviesState {}

final class WatchlistMoviesEmpty extends WatchlistMoviesState {
  final String message;

  const WatchlistMoviesEmpty(this.message);

  @override
  List<Object?> get props => [message];
}

final class WatchlistMoviesHasError extends WatchlistMoviesState {
  final String message;

  const WatchlistMoviesHasError(this.message);

  @override
  List<Object?> get props => [message];
}

final class WatchlistMoviesHasData extends WatchlistMoviesState {
  final List<Movie> movie;

  const WatchlistMoviesHasData(this.movie);

  @override
  List<Object?> get props => [movie];
}

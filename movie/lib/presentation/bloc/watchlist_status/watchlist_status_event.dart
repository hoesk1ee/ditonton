part of 'watchlist_status_bloc.dart';

sealed class WatchlistStatusEvent extends Equatable {
  const WatchlistStatusEvent();

  @override
  List<Object?> get props => [];
}

class GetMovieWatchlistStatus extends WatchlistStatusEvent {
  final int movieId;

  const GetMovieWatchlistStatus(this.movieId);

  @override
  List<Object?> get props => [];
}

class AddMovieToWatchlist extends WatchlistStatusEvent {
  final MovieDetail movie;

  const AddMovieToWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

class RemoveMovieFromWatchlist extends WatchlistStatusEvent {
  final MovieDetail movie;

  const RemoveMovieFromWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

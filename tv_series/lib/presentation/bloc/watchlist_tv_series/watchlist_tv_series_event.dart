part of 'watchlist_tv_series_bloc.dart';

sealed class WatchlistTvSeriesEvent extends Equatable {
  const WatchlistTvSeriesEvent();

  @override
  List<Object?> get props => [];
}

class FetchTvSeriesWatchlist extends WatchlistTvSeriesEvent {}

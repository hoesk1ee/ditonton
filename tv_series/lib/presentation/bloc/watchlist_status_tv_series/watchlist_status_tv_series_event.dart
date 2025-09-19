part of 'watchlist_status_tv_series_bloc.dart';

sealed class WatchlistStatusTvSeriesEvent extends Equatable {
  const WatchlistStatusTvSeriesEvent();

  @override
  List<Object?> get props => [];
}

class GetTvSeriesWatchlistStatus extends WatchlistStatusTvSeriesEvent {
  final int tvSeriesId;

  const GetTvSeriesWatchlistStatus(this.tvSeriesId);

  @override
  List<Object?> get props => [];
}

class AddTvSeriesToWatchlist extends WatchlistStatusTvSeriesEvent {
  final TvSeriesDetail tvSeries;

  const AddTvSeriesToWatchlist(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

class RemoveTvSeriesFromWatchlist extends WatchlistStatusTvSeriesEvent {
  final TvSeriesDetail tvSeries;

  const RemoveTvSeriesFromWatchlist(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

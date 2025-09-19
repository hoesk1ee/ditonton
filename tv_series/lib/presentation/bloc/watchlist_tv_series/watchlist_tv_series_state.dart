part of 'watchlist_tv_series_bloc.dart';

sealed class WatchlistTvSeriesState extends Equatable {
  const WatchlistTvSeriesState();

  @override
  List<Object?> get props => [];
}

final class WatchlistTvSeriesInitial extends WatchlistTvSeriesState {}

final class WatchlistTvSeriesLoading extends WatchlistTvSeriesState {}

final class WatchlistTvSeriesEmpty extends WatchlistTvSeriesState {
  final String message;

  const WatchlistTvSeriesEmpty(this.message);

  @override
  List<Object?> get props => [message];
}

final class WatchlistTvSeriesHasError extends WatchlistTvSeriesState {
  final String message;

  const WatchlistTvSeriesHasError(this.message);

  @override
  List<Object?> get props => [message];
}

final class WatchlistTvSeriesHasData extends WatchlistTvSeriesState {
  final List<TvSeries> tvSeries;

  const WatchlistTvSeriesHasData(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

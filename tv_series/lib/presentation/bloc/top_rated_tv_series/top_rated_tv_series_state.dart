part of 'top_rated_tv_series_bloc.dart';

sealed class TopRatedTvSeriesState extends Equatable {
  const TopRatedTvSeriesState();

  @override
  List<Object?> get props => [];
}

final class TopRatedTvSeriesInitial extends TopRatedTvSeriesState {}

final class TopRatedTvSeriesLoading extends TopRatedTvSeriesState {}

final class TopRatedTvSeriesEmpty extends TopRatedTvSeriesState {
  final String message;

  const TopRatedTvSeriesEmpty(this.message);

  @override
  List<Object?> get props => [message];
}

final class TopRatedTvSeriesHasError extends TopRatedTvSeriesState {
  final String message;

  const TopRatedTvSeriesHasError(this.message);

  @override
  List<Object?> get props => [message];
}

final class TopRatedTvSeriesHasData extends TopRatedTvSeriesState {
  final List<TvSeries> result;

  const TopRatedTvSeriesHasData(this.result);

  @override
  List<Object?> get props => [result];
}

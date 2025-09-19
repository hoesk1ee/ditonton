part of 'popular_tv_series_bloc.dart';

sealed class PopularTvSeriesState extends Equatable {
  const PopularTvSeriesState();

  @override
  List<Object?> get props => [];
}

final class PopularTvSeriesInitial extends PopularTvSeriesState {}

final class PopularTvSeriesEmpty extends PopularTvSeriesState {
  final String message;

  const PopularTvSeriesEmpty(this.message);

  @override
  List<Object?> get props => [message];
}

final class PopularTvSeriesLoading extends PopularTvSeriesState {}

final class PopularTvSeriesHasError extends PopularTvSeriesState {
  final String message;

  const PopularTvSeriesHasError(this.message);

  @override
  List<Object?> get props => [message];
}

final class PopularTvSeriesHasData extends PopularTvSeriesState {
  final List<TvSeries> result;

  const PopularTvSeriesHasData(this.result);

  @override
  List<Object?> get props => [result];
}

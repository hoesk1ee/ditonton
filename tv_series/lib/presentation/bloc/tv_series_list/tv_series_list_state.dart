part of 'tv_series_list_bloc.dart';

sealed class TvSeriesListState extends Equatable {
  const TvSeriesListState();

  @override
  List<Object?> get props => [];
}

final class TvSeriesListInitial extends TvSeriesListState {}

final class TvSeriesListLoading extends TvSeriesListState {}

final class TvSeriesListHasError extends TvSeriesListState {
  final String message;

  TvSeriesListHasError(this.message);

  @override
  List<Object?> get props => [message];
}

final class TvSeriesListHasData extends TvSeriesListState {
  final List<TvSeries> onTheAirResult;
  final List<TvSeries> popularResult;
  final List<TvSeries> topRatedResult;

  TvSeriesListHasData(
    this.onTheAirResult,
    this.popularResult,
    this.topRatedResult,
  );

  @override
  List<Object?> get props => [onTheAirResult, popularResult, topRatedResult];
}

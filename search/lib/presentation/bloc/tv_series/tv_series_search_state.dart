part of 'tv_series_search_bloc.dart';

sealed class TvSeriesSearchState extends Equatable {
  const TvSeriesSearchState();

  @override
  List<Object> get props => [];
}

class TvSeriesSearchInitial extends TvSeriesSearchState {}

class TvSeriesSearchEmpty extends TvSeriesSearchState {
  final String message;

  const TvSeriesSearchEmpty(this.message);

  @override
  List<Object> get props => [message];
}

class TvSeriesSearchLoading extends TvSeriesSearchState {}

class TvSeriesSearchHasError extends TvSeriesSearchState {
  final String message;

  const TvSeriesSearchHasError(this.message);

  @override
  List<Object> get props => [message];
}

class TvSeriesSearchHasData extends TvSeriesSearchState {
  final List<TvSeries> result;

  const TvSeriesSearchHasData(this.result);

  @override
  List<Object> get props => [result];
}

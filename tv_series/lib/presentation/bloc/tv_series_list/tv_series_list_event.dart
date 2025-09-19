part of 'tv_series_list_bloc.dart';

sealed class TvSeriesListEvent extends Equatable {
  const TvSeriesListEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllTvSeriesList extends TvSeriesListEvent {}

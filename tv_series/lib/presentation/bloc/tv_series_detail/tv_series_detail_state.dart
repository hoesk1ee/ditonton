part of 'tv_series_detail_bloc.dart';

sealed class TvSeriesDetailState extends Equatable {
  const TvSeriesDetailState();

  @override
  List<Object?> get props => [];
}

final class TvSeriesDetailInitial extends TvSeriesDetailState {}

class TvSeriesDetailLoading extends TvSeriesDetailState {}

class TvSeriesDetailHasError extends TvSeriesDetailState {
  final String message;

  TvSeriesDetailHasError(this.message);

  @override
  List<Object?> get props => [message];
}

final class TvSeriesDetailHasData extends TvSeriesDetailState {
  final TvSeriesDetail tvSeriesDetail;
  final List<TvSeries> recommendations;

  TvSeriesDetailHasData(this.tvSeriesDetail, this.recommendations);

  @override
  List<Object?> get props => [TvSeriesDetail, recommendations];
}

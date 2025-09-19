import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../tv_series.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  final GetTvSeriesDetail _getTvSeriesDetail;
  final GetTvSeriesRecommendations _getTvSeriesRecommendations;

  TvSeriesDetailBloc(this._getTvSeriesDetail, this._getTvSeriesRecommendations)
    : super(TvSeriesDetailInitial()) {
    on<FetchTvSeriesDetail>((event, emit) async {
      emit(TvSeriesDetailLoading());

      final detailResult = await _getTvSeriesDetail.execute(event.id);
      final recommendationsResult = await _getTvSeriesRecommendations.execute(
        event.id,
      );

      detailResult.fold(
        (failure) {
          emit(TvSeriesDetailHasError("Server Failure"));
        },
        (tvSeries) {
          recommendationsResult.fold(
            (failure) {
              emit(TvSeriesDetailHasError("Server Failure"));
            },
            (recommendations) {
              emit(TvSeriesDetailHasData(tvSeries, recommendations));
            },
          );
        },
      );
    });
  }
}

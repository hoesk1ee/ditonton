import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

part 'tv_series_list_event.dart';
part 'tv_series_list_state.dart';

class TvSeriesListBloc extends Bloc<TvSeriesListEvent, TvSeriesListState> {
  // * Initiate Repo
  final GetOnTheAirTvSeries _getOnTheAirTvSeries;
  final GetPopularTvSeries _getPopularTvSeries;
  final GetTopRatedTvSeries _getTopRatedTvSeries;

  TvSeriesListBloc(
    this._getOnTheAirTvSeries,
    this._getPopularTvSeries,
    this._getTopRatedTvSeries,
  ) : super(TvSeriesListInitial()) {
    on<FetchAllTvSeriesList>((event, emit) async {
      // * Emit/send first state to bloc
      emit(TvSeriesListLoading());

      final onTheAirResult = await _getOnTheAirTvSeries.execute();
      final popularResult = await _getPopularTvSeries.execute();
      final topRatedResult = await _getTopRatedTvSeries.execute();

      if (onTheAirResult.isLeft() ||
          popularResult.isLeft() ||
          topRatedResult.isLeft()) {
        emit(TvSeriesListHasError("Server Failure"));
        return;
      }

      final onTheAir = onTheAirResult.getOrElse(() => []);
      final popular = popularResult.getOrElse(() => []);
      final topRated = topRatedResult.getOrElse(() => []);

      emit(TvSeriesListHasData(onTheAir, popular, topRated));
    });
  }
}

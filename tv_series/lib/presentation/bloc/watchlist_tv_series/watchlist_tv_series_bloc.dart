import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries _getWatchlistTvSeries;

  WatchlistTvSeriesBloc(this._getWatchlistTvSeries)
    : super(WatchlistTvSeriesInitial()) {
    on<FetchTvSeriesWatchlist>((event, emit) async {
      emit(WatchlistTvSeriesLoading());

      final result = await _getWatchlistTvSeries.execute();

      result.fold(
        (failure) {
          emit(WatchlistTvSeriesHasError("Database Failure"));
        },
        (data) {
          if (data.isEmpty) {
            emit(WatchlistTvSeriesEmpty("No tv series added to watchlist"));
          } else {
            emit(WatchlistTvSeriesHasData(data));
          }
        },
      );
    });
  }
}

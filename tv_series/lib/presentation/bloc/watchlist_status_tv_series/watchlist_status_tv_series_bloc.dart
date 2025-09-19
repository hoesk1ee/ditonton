import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

part 'watchlist_status_tv_series_event.dart';
part 'watchlist_status_tv_series_state.dart';

class WatchlistStatusTvSeriesBloc
    extends Bloc<WatchlistStatusTvSeriesEvent, WatchlistStatusTvSeriesState> {
  final SaveTvSeriesWatchlist _saveTvSeriesWatchlist;
  final RemoveTvSeriesWatchlist _removeTvSeriesWatchlist;
  final GetWatchlistTvSeriesStatus _getWatchlistTvSeriesStatus;

  WatchlistStatusTvSeriesBloc(
    this._saveTvSeriesWatchlist,
    this._removeTvSeriesWatchlist,
    this._getWatchlistTvSeriesStatus,
  ) : super(WatchlistStatusTvSeriesState()) {
    on<GetTvSeriesWatchlistStatus>((event, emit) async {
      final isAdded = await _getWatchlistTvSeriesStatus.execute(
        event.tvSeriesId,
      );
      emit(state.copyWith(isAdded: isAdded, message: ""));
    });

    on<AddTvSeriesToWatchlist>((event, emit) async {
      final result = await _saveTvSeriesWatchlist.execute(event.tvSeries);

      String message = '';
      bool isAdded = false;

      result.fold(
        (failure) => message = failure.message,
        (successMessage) => message = successMessage,
      );

      if (!message.contains('Failure')) {
        isAdded = await _getWatchlistTvSeriesStatus.execute(event.tvSeries.id);
      }

      emit(state.copyWith(message: message, isAdded: isAdded));
    });

    on<RemoveTvSeriesFromWatchlist>((event, emit) async {
      final result = await _removeTvSeriesWatchlist.execute(event.tvSeries);

      String message = '';
      bool isAdded = false;

      result.fold(
        (failure) => message = failure.message,
        (successMessage) => message = successMessage,
      );

      if (!message.contains('Failure')) {
        isAdded = await _getWatchlistTvSeriesStatus.execute(event.tvSeries.id);
      }

      emit(state.copyWith(message: message, isAdded: isAdded));
    });
  }
}

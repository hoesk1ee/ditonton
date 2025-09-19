import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

part 'watchlist_status_event.dart';
part 'watchlist_status_state.dart';

class WatchlistStatusBloc
    extends Bloc<WatchlistStatusEvent, WatchlistStatusState> {
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;
  final GetWatchListStatus _getWatchListStatus;

  WatchlistStatusBloc(
    this._saveWatchlist,
    this._removeWatchlist,
    this._getWatchListStatus,
  ) : super(WatchlistStatusState()) {
    on<GetMovieWatchlistStatus>((event, emit) async {
      final isAdded = await _getWatchListStatus.execute(event.movieId);
      emit(state.copyWith(isAdded: isAdded, message: ""));
    });

    on<AddMovieToWatchlist>((event, emit) async {
      final result = await _saveWatchlist.execute(event.movie);

      String message = '';
      bool isAdded = false;

      result.fold(
        (failure) => message = failure.message,
        (successMessage) => message = successMessage,
      );

      if (!message.contains('Failure')) {
        isAdded = await _getWatchListStatus.execute(event.movie.id);
      }

      emit(state.copyWith(message: message, isAdded: isAdded));
    });

    on<RemoveMovieFromWatchlist>((event, emit) async {
      final result = await _removeWatchlist.execute(event.movie);

      String message = '';
      bool isAdded = false;

      result.fold(
        (failure) => message = failure.message,
        (successMessage) => message = successMessage,
      );

      if (!message.contains('Failure')) {
        isAdded = await _getWatchListStatus.execute(event.movie.id);
      }

      emit(state.copyWith(message: message, isAdded: isAdded));
    });
  }
}

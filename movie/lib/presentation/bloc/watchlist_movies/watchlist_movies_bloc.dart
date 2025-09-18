import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies _getWatchlistMovies;

  WatchlistMoviesBloc(this._getWatchlistMovies)
    : super(WatchlistMoviesInitial()) {
    on<FetchMovieWatchlist>((event, emit) async {
      emit(WatchlistMoviesLoading());

      final result = await _getWatchlistMovies.execute();

      result.fold(
        (failure) {
          emit(WatchlistMoviesHasError("Database Failure"));
        },
        (data) {
          if (data.isEmpty) {
            emit(WatchlistMoviesEmpty("No movie added to watchlist"));
          } else {
            emit(WatchlistMoviesHasData(data));
          }
        },
      );
    });
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  // * Initiate Repo
  final GetNowPlayingMovies _getNowPlayingMovies;

  MovieListBloc(this._getNowPlayingMovies) : super(MovieListInitial()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      // * Emit/send first state to bloc
      emit(MovieListLoading());

      final result = await _getNowPlayingMovies.execute();

      result.fold(
        (failure) {
          emit(MovieListHasError("Server Failure"));
        },
        (data) {
          if (data.isEmpty) {
            emit(MovieListEmpty("No movie available."));
          } else {
            emit(MovieListHasData(data));
          }
        },
      );
    });
  }
}

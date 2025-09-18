import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  // * Initiate Repo
  final GetNowPlayingMovies _getNowPlayingMovies;
  final GetPopularMovies _getPopularMovies;
  final GetTopRatedMovies _getTopRatedMovies;

  MovieListBloc(
    this._getNowPlayingMovies,
    this._getPopularMovies,
    this._getTopRatedMovies,
  ) : super(MovieListInitial()) {
    on<FetchAllMovieLists>((event, emit) async {
      // * Emit/send first state to bloc
      emit(MovieListLoading());

      final nowPlayingResult = await _getNowPlayingMovies.execute();
      final popularResult = await _getPopularMovies.execute();
      final topRatedResult = await _getTopRatedMovies.execute();

      if (nowPlayingResult.isLeft() ||
          popularResult.isLeft() ||
          topRatedResult.isLeft()) {
        emit(MovieListHasError("Server Failure"));
        return;
      }

      final nowPlaying = nowPlayingResult.getOrElse(() => []);
      final popular = popularResult.getOrElse(() => []);
      final topRated = topRatedResult.getOrElse(() => []);

      emit(MovieListHasData(nowPlaying, popular, topRated));
    });
  }
}

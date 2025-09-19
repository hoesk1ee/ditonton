import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies _getPopularMovies;

  PopularMoviesBloc(this._getPopularMovies) : super(PopularMoviesInitial()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(PopularMoviesLoading());

      final result = await _getPopularMovies.execute();

      result.fold(
        (failure) {
          emit(PopularMoviesHasError("Server Failure"));
        },
        (data) {
          if (data.isEmpty) {
            emit(PopularMoviesEmpty("No popular movie found"));
          } else {
            emit(PopularMoviesHasData(data));
          }
        },
      );
    });
  }
}

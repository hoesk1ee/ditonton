import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMoviesBloc(this._getTopRatedMovies) : super(TopRatedMoviesInitial()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(TopRatedMoviesLoading());

      final result = await _getTopRatedMovies.execute();

      result.fold(
        (failure) {
          emit(TopRatedMoviesHasError("Server Failure"));
        },
        (data) {
          if (data.isEmpty) {
            emit(TopRatedMoviesEmpty("No top rated movie found"));
          } else {
            emit(TopRatedMoviesHasData(data));
          }
        },
      );
    });
  }
}

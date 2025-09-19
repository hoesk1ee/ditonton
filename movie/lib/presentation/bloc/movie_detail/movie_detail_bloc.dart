import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;

  MovieDetailBloc(this._getMovieDetail, this._getMovieRecommendations)
    : super(MovieDetailInitial()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieDetailLoading());

      final detailResult = await _getMovieDetail.execute(event.id);
      final recommendationsResult = await _getMovieRecommendations.execute(
        event.id,
      );

      detailResult.fold(
        (failure) {
          emit(MovieDetailHasError("Server Failure"));
        },
        (movie) {
          recommendationsResult.fold(
            (failure) {
              emit(MovieDetailHasError("Server Failure"));
            },
            (recommendations) {
              emit(MovieDetailHasData(movie, recommendations));
            },
          );
        },
      );
    });
  }
}

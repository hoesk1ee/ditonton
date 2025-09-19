part of 'movie_detail_bloc.dart';

sealed class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object?> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailHasError extends MovieDetailState {
  final String message;

  MovieDetailHasError(this.message);

  @override
  List<Object?> get props => [message];
}

final class MovieDetailHasData extends MovieDetailState {
  final MovieDetail movieDetail;
  final List<Movie> recommendations;

  MovieDetailHasData(this.movieDetail, this.recommendations);

  @override
  List<Object?> get props => [movieDetail, recommendations];
}

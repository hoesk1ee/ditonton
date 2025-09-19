import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail, GetMovieRecommendations])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieDetailBloc = MovieDetailBloc(
      mockGetMovieDetail,
      mockGetMovieRecommendations,
    );
  });

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovieList = [tMovie];

  test("Initial state should be empty", () {
    expect(movieDetailBloc.state, MovieDetailInitial());
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit [Loading, HasData] when data is fetched successfully',
    build: () {
      when(
        mockGetMovieDetail.execute(1),
      ).thenAnswer((_) async => Right(tMovieDetail));
      when(
        mockGetMovieRecommendations.execute(1),
      ).thenAnswer((_) async => Right(tMovieList));

      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(1)),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailHasData(tMovieDetail, tMovieList),
    ],
    verify: (_) {
      verify(mockGetMovieDetail.execute(1));
      verify(mockGetMovieRecommendations.execute(1));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit [Loading, HasError] when fetching movie detail fails',
    build: () {
      when(
        mockGetMovieDetail.execute(1),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockGetMovieRecommendations.execute(1),
      ).thenAnswer((_) async => Right(tMovieList));

      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(1)),
    expect: () => [MovieDetailLoading(), MovieDetailHasError('Server Failure')],
    verify: (_) {
      verify(mockGetMovieDetail.execute(1));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit [Loading, HasError] when fetching movie recommendation fails',
    build: () {
      when(
        mockGetMovieDetail.execute(1),
      ).thenAnswer((_) async => Right(tMovieDetail));
      when(
        mockGetMovieRecommendations.execute(1),
      ).thenAnswer((_) async => Left(ServerFailure("Server Failure")));

      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(1)),
    expect: () => [MovieDetailLoading(), MovieDetailHasError('Server Failure')],
    verify: (_) {
      verify(mockGetMovieDetail.execute(1));
    },
  );
}

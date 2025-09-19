import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/watchlist_movies/watchlist_movies_bloc.dart';

import 'watchlist_movies_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late WatchlistMoviesBloc watchlistMoviesBloc;

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

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMoviesBloc = WatchlistMoviesBloc(mockGetWatchlistMovies);
  });

  test("Initate state should be empty", () {
    expect(watchlistMoviesBloc.state, WatchlistMoviesInitial());
  });

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    "Should emit [Loading, HasData] when data is fetched successfully",
    build: () {
      when(
        mockGetWatchlistMovies.execute(),
      ).thenAnswer((_) async => Right(tMovieList));

      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchMovieWatchlist()),
    expect: () => [
      WatchlistMoviesLoading(),
      WatchlistMoviesHasData(tMovieList),
    ],
    verify: (bloc) => mockGetWatchlistMovies.execute(),
  );

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    "Should emit [Loading, HasError] when data is failed to fetch",
    build: () {
      when(
        mockGetWatchlistMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure("Database Failure")));

      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchMovieWatchlist()),
    expect: () => [
      WatchlistMoviesLoading(),
      WatchlistMoviesHasError("Database Failure"),
    ],
    verify: (bloc) => mockGetWatchlistMovies.execute(),
  );

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    "Should emit [Loading, Empty] when no movie added to watchlist",
    build: () {
      when(mockGetWatchlistMovies.execute()).thenAnswer((_) async => Right([]));

      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchMovieWatchlist()),
    expect: () => [
      WatchlistMoviesLoading(),
      WatchlistMoviesEmpty("No movie added to watchlist"),
    ],
    verify: (bloc) => mockGetWatchlistMovies.execute(),
  );
}

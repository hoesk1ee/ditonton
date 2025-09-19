import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:tv_series/tv_series.dart';

import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late WatchlistTvSeriesBloc watchlistTvSeriesBloc;

  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalName: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    firstAirDate: '2002-05-01',
    name: 'Spider-Man',
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTvSeriesList = [tTvSeries];

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    watchlistTvSeriesBloc = WatchlistTvSeriesBloc(mockGetWatchlistTvSeries);
  });

  test("Initate state should be empty", () {
    expect(watchlistTvSeriesBloc.state, WatchlistTvSeriesInitial());
  });

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    "Should emit [Loading, HasData] when data is fetched successfully",
    build: () {
      when(
        mockGetWatchlistTvSeries.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));

      return watchlistTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchTvSeriesWatchlist()),
    expect: () => [
      WatchlistTvSeriesLoading(),
      WatchlistTvSeriesHasData(tTvSeriesList),
    ],
    verify: (bloc) => mockGetWatchlistTvSeries.execute(),
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    "Should emit [Loading, HasError] when data is failed to fetch",
    build: () {
      when(
        mockGetWatchlistTvSeries.execute(),
      ).thenAnswer((_) async => Left(ServerFailure("Database Failure")));

      return watchlistTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchTvSeriesWatchlist()),
    expect: () => [
      WatchlistTvSeriesLoading(),
      WatchlistTvSeriesHasError("Database Failure"),
    ],
    verify: (bloc) => mockGetWatchlistTvSeries.execute(),
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    "Should emit [Loading, Empty] when no tv series added to watchlist",
    build: () {
      when(
        mockGetWatchlistTvSeries.execute(),
      ).thenAnswer((_) async => Right([]));

      return watchlistTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchTvSeriesWatchlist()),
    expect: () => [
      WatchlistTvSeriesLoading(),
      WatchlistTvSeriesEmpty("No tv series added to watchlist"),
    ],
    verify: (bloc) => mockGetWatchlistTvSeries.execute(),
  );
}

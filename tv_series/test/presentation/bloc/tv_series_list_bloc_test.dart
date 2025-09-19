import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/presentation/bloc/tv_series_list/tv_series_list_bloc.dart';
import 'package:tv_series/tv_series.dart';

import 'tv_series_list_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTvSeries, GetPopularTvSeries, GetTopRatedTvSeries])
void main() {
  late TvSeriesListBloc tvSeriesListBloc;
  late MockGetOnTheAirTvSeries mockGetOnTheAirTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetOnTheAirTvSeries = MockGetOnTheAirTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    tvSeriesListBloc = TvSeriesListBloc(
      mockGetOnTheAirTvSeries,
      mockGetPopularTvSeries,
      mockGetTopRatedTvSeries,
    );
  });

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

  test("Initial state should be empty", () {
    expect(tvSeriesListBloc.state, TvSeriesListInitial());
  });

  blocTest<TvSeriesListBloc, TvSeriesListState>(
    'should emit [Loading, HasData] when data is fetched successfully',
    build: () {
      when(
        mockGetOnTheAirTvSeries.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      when(
        mockGetPopularTvSeries.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      when(
        mockGetTopRatedTvSeries.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));

      return tvSeriesListBloc;
    },
    act: (bloc) => bloc.add(FetchAllTvSeriesList()),
    expect: () => [
      TvSeriesListLoading(),
      TvSeriesListHasData(tTvSeriesList, tTvSeriesList, tTvSeriesList),
    ],
    verify: (_) {
      verify(mockGetOnTheAirTvSeries.execute());
      verify(mockGetPopularTvSeries.execute());
      verify(mockGetTopRatedTvSeries.execute());
    },
  );

  blocTest<TvSeriesListBloc, TvSeriesListState>(
    'should emit [Loading, HasError] when data is fetching fails',
    build: () {
      when(
        mockGetOnTheAirTvSeries.execute(),
      ).thenAnswer((_) async => Left(ServerFailure("Server Failure")));
      when(
        mockGetPopularTvSeries.execute(),
      ).thenAnswer((_) async => Left(ServerFailure("Server Failure")));
      when(
        mockGetTopRatedTvSeries.execute(),
      ).thenAnswer((_) async => Left(ServerFailure("Server Failure")));

      return tvSeriesListBloc;
    },
    act: (bloc) => bloc.add(FetchAllTvSeriesList()),
    expect: () => [
      TvSeriesListLoading(),
      TvSeriesListHasError("Server Failure"),
    ],
    verify: (_) {
      verify(mockGetOnTheAirTvSeries.execute());
      verify(mockGetPopularTvSeries.execute());
      verify(mockGetTopRatedTvSeries.execute());
    },
  );
}

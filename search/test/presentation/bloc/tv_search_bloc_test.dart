import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/presentation/bloc/tv_series/tv_series_search_bloc.dart';
import 'package:search/search.dart';
import 'package:tv_series/tv_series.dart';

import 'tv_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvSeriesSearchBloc tvSeriesSearchBloc;
  late MockSearchTvSeries mockSearchTvSeries;

  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: '/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg',
    genreIds: [18, 80],
    id: 1396,
    originalName: 'Breaking Bad',
    overview:
        'Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family\'s financial future at any cost as he enters the dangerous world of drugs and crime.',
    popularity: 99.752,
    posterPath: '/ztkUQFLlC19CCMYHW9o1zWhJRNq.jpg',
    firstAirDate: '2008-01-20",',
    name: 'Breaking Bad',
    voteAverage: 8.919,
    voteCount: 16051,
  );
  final tTvSeriesList = <TvSeries>[tTvSeries];
  final tQuery = 'breaking bad';

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    tvSeriesSearchBloc = TvSeriesSearchBloc(mockSearchTvSeries);
  });

  test('initial state of tv series should be empty', () {
    expect(tvSeriesSearchBloc.state, TvSeriesSearchInitial());
  });

  blocTest(
    "Should emit [Loading, Empty] when no data found",
    build: () {
      when(
        mockSearchTvSeries.execute(tQuery),
      ).thenAnswer((_) async => Right([]));
      return tvSeriesSearchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeriesSearchLoading(),
      TvSeriesSearchEmpty("No TV series found"),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );

  blocTest(
    "Should emit [Loading, HasData] when data is gotten successfully",
    build: () {
      when(
        mockSearchTvSeries.execute(tQuery),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      return tvSeriesSearchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeriesSearchLoading(),
      TvSeriesSearchHasData(tTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );

  blocTest(
    "Should emit [Loading, HasError] when data is failed",
    build: () {
      when(
        mockSearchTvSeries.execute(tQuery),
      ).thenAnswer((_) async => Left(ServerFailure("Server Failure")));
      return tvSeriesSearchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeriesSearchLoading(),
      TvSeriesSearchHasError("Server Failure"),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
}

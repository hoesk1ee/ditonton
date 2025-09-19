import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';

import 'popular_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late PopularTvSeriesBloc popularTvSeriesBloc;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    popularTvSeriesBloc = PopularTvSeriesBloc(mockGetPopularTvSeries);
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
    expect(popularTvSeriesBloc.state, PopularTvSeriesInitial());
  });

  blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
    "Should emit [Loading, HasData] when data is fetched successfully",
    build: () {
      when(
        mockGetPopularTvSeries.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));

      return popularTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvSeries()),
    expect: () => [
      PopularTvSeriesLoading(),
      PopularTvSeriesHasData(tTvSeriesList),
    ],
    verify: (bloc) => mockGetPopularTvSeries.execute(),
  );

  blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
    "Should emit [Loading, HasError] when data failed to fetch",
    build: () {
      when(
        mockGetPopularTvSeries.execute(),
      ).thenAnswer((_) async => Left(ServerFailure("Server Failure")));

      return popularTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvSeries()),
    expect: () => [
      PopularTvSeriesLoading(),
      PopularTvSeriesHasError("Server Failure"),
    ],
    verify: (bloc) => mockGetPopularTvSeries.execute(),
  );
}

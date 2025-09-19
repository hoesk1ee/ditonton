import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';

import 'top_rated_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late TopRatedTvSeriesBloc topRatedTvSeriesBloc;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    topRatedTvSeriesBloc = TopRatedTvSeriesBloc(mockGetTopRatedTvSeries);
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
    expect(topRatedTvSeriesBloc.state, TopRatedTvSeriesInitial());
  });

  blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
    "Should emit [Loading, HasData] when data is fetched successfully",
    build: () {
      when(
        mockGetTopRatedTvSeries.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));

      return topRatedTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
    expect: () => [
      TopRatedTvSeriesLoading(),
      TopRatedTvSeriesHasData(tTvSeriesList),
    ],
    verify: (bloc) => mockGetTopRatedTvSeries.execute(),
  );

  blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
    "Should emit [Loading, HasError] when data failed to fetch",
    build: () {
      when(
        mockGetTopRatedTvSeries.execute(),
      ).thenAnswer((_) async => Left(ServerFailure("Server Failure")));

      return topRatedTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
    expect: () => [
      TopRatedTvSeriesLoading(),
      TopRatedTvSeriesHasError("Server Failure"),
    ],
    verify: (bloc) => mockGetTopRatedTvSeries.execute(),
  );
}

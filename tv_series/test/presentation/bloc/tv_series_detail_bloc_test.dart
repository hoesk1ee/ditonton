import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:tv_series/tv_series.dart';

import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesDetail, GetTvSeriesRecommendations])
void main() {
  late TvSeriesDetailBloc tvSeriesDetailBloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    tvSeriesDetailBloc = TvSeriesDetailBloc(
      mockGetTvSeriesDetail,
      mockGetTvSeriesRecommendations,
    );
  });

  final tTvSeriesDetail = TvSeriesDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    numberOfEpisodes: 10,
    numberOfSeasons: 2,
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

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
    expect(tvSeriesDetailBloc.state, TvSeriesDetailInitial());
  });

  blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    'should emit [Loading, HasData] when data is fetched successfully',
    build: () {
      when(
        mockGetTvSeriesDetail.execute(1),
      ).thenAnswer((_) async => Right(tTvSeriesDetail));
      when(
        mockGetTvSeriesRecommendations.execute(1),
      ).thenAnswer((_) async => Right(tTvSeriesList));

      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(FetchTvSeriesDetail(1)),
    expect: () => [
      TvSeriesDetailLoading(),
      TvSeriesDetailHasData(tTvSeriesDetail, tTvSeriesList),
    ],
    verify: (_) {
      verify(mockGetTvSeriesDetail.execute(1));
      verify(mockGetTvSeriesRecommendations.execute(1));
    },
  );

  blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    'should emit [Loading, HasError] when fetching Tv Series detail fails',
    build: () {
      when(
        mockGetTvSeriesDetail.execute(1),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockGetTvSeriesRecommendations.execute(1),
      ).thenAnswer((_) async => Right(tTvSeriesList));

      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(FetchTvSeriesDetail(1)),
    expect: () => [
      TvSeriesDetailLoading(),
      TvSeriesDetailHasError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetTvSeriesDetail.execute(1));
    },
  );

  blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    'should emit [Loading, HasError] when fetching tv series recommendation fails',
    build: () {
      when(
        mockGetTvSeriesDetail.execute(1),
      ).thenAnswer((_) async => Right(tTvSeriesDetail));
      when(
        mockGetTvSeriesRecommendations.execute(1),
      ).thenAnswer((_) async => Left(ServerFailure("Server Failure")));

      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(FetchTvSeriesDetail(1)),
    expect: () => [
      TvSeriesDetailLoading(),
      TvSeriesDetailHasError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetTvSeriesDetail.execute(1));
    },
  );
}

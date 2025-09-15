import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_tv_series_detail.dart';
import 'package:core/domain/usecases/get_tv_series_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_tv_series_status.dart';
import 'package:core/domain/usecases/remove_tv_series_watchlist.dart';
import 'package:core/domain/usecases/save_tv_series_watchlist.dart';
import 'package:core/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchlistTvSeriesStatus,
  SaveTvSeriesWatchlist,
  RemoveTvSeriesWatchlist,
])
void main() {
  late TvSeriesDetailNotifier provider;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchlistTvSeriesStatus mockGetWatchlistTvSeriesStatus;
  late MockSaveTvSeriesWatchlist mockSaveTvSeriesWatchlist;
  late MockRemoveTvSeriesWatchlist mockRemoveTvSeriesWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchlistTvSeriesStatus = MockGetWatchlistTvSeriesStatus();
    mockSaveTvSeriesWatchlist = MockSaveTvSeriesWatchlist();
    mockRemoveTvSeriesWatchlist = MockRemoveTvSeriesWatchlist();
    provider =
        TvSeriesDetailNotifier(
          getTvSeriesDetail: mockGetTvSeriesDetail,
          getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
          getWatchListStatus: mockGetWatchlistTvSeriesStatus,
          saveTvSeriesWatchlist: mockSaveTvSeriesWatchlist,
          removeTvSeriesWatchlist: mockRemoveTvSeriesWatchlist,
        )..addListener(() {
          listenerCallCount += 1;
        });
  });

  final tId = 1;

  final tTvSerial = TvSeries(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvSeries = <TvSeries>[tTvSerial];

  void _arrangeUsecase() {
    when(
      mockGetTvSeriesDetail.execute(tId),
    ).thenAnswer((_) async => Right(testTvSeriesDetail));
    when(
      mockGetTvSeriesRecommendations.execute(tId),
    ).thenAnswer((_) async => Right(tTvSeries));
  }

  group('Get Tv Series Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      verify(mockGetTvSeriesDetail.execute(tId));
      verify(mockGetTvSeriesRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.tvSerialState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv series when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.tvSerialState, RequestState.Loaded);
      expect(provider.tvSerial, testTvSeriesDetail);
      expect(listenerCallCount, 3);
    });

    test(
      'should change recommendation tv series when data is gotten successfully',
      () async {
        // arrange
        _arrangeUsecase();
        // act
        await provider.fetchTvSeriesDetail(tId);
        // assert
        expect(provider.tvSerialState, RequestState.Loaded);
        expect(provider.tvSeriesRecommendations, tTvSeries);
      },
    );
  });

  group('Get Tv Series Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      verify(mockGetTvSeriesRecommendations.execute(tId));
      expect(provider.tvSeriesRecommendations, tTvSeries);
    });

    test(
      'should update recommendation state when data is gotten successfully',
      () async {
        // arrange
        _arrangeUsecase();
        // act
        await provider.fetchTvSeriesDetail(tId);
        // assert
        expect(provider.recommendationState, RequestState.Loaded);
        expect(provider.tvSeriesRecommendations, tTvSeries);
      },
    );

    test('should update error message when request in successful', () async {
      // arrange
      when(
        mockGetTvSeriesDetail.execute(tId),
      ).thenAnswer((_) async => Right(testTvSeriesDetail));
      when(
        mockGetTvSeriesRecommendations.execute(tId),
      ).thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(
        mockGetWatchlistTvSeriesStatus.execute(1),
      ).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(
        mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail),
      ).thenAnswer((_) async => Right('Success'));
      when(
        mockGetWatchlistTvSeriesStatus.execute(testTvSeriesDetail.id),
      ).thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTvSeriesDetail);
      // assert
      verify(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(
        mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail),
      ).thenAnswer((_) async => Right('Removed'));
      when(
        mockGetWatchlistTvSeriesStatus.execute(testTvSeriesDetail.id),
      ).thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(testTvSeriesDetail);
      // assert
      verify(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(
        mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail),
      ).thenAnswer((_) async => Right('Added to Watchlist'));
      when(
        mockGetWatchlistTvSeriesStatus.execute(testTvSeriesDetail.id),
      ).thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTvSeriesDetail);
      // assert
      verify(mockGetWatchlistTvSeriesStatus.execute(testTvSeriesDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(
        mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(
        mockGetWatchlistTvSeriesStatus.execute(testTvSeriesDetail.id),
      ).thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(testTvSeriesDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetTvSeriesDetail.execute(tId),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockGetTvSeriesRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tTvSeries));
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.tvSerialState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}

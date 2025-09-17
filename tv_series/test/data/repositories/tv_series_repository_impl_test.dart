import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:core/data/models/genre_model.dart';

import 'package:core/core.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvSeriesModel = TvSeriesModel(
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

  final tTvSeriesModelList = <TvSeriesModel>[tTvSeriesModel];
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('On The Air Tv Series', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getOnTheAirTvSeries(),
        ).thenAnswer((_) async => tTvSeriesModelList);
        // act
        final result = await repository.getOnTheAirTvSeries();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTvSeries());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getOnTheAirTvSeries(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getOnTheAirTvSeries();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTvSeries());
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getOnTheAirTvSeries(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getOnTheAirTvSeries();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTvSeries());
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Popular Tv Series', () {
    test(
      'should return tv series list when call to data source is success',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvSeries(),
        ).thenAnswer((_) async => tTvSeriesModelList);
        // act
        final result = await repository.getPopularTvSeries();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      },
    );

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvSeries(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getPopularTvSeries();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvSeries(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getPopularTvSeries();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Top Rated Tv Series', () {
    test(
      'should return tv series list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTvSeries(),
        ).thenAnswer((_) async => tTvSeriesModelList);
        // act
        final result = await repository.getTopRatedTvSeries();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTvSeries(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedTvSeries();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTvSeries(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTopRatedTvSeries();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get Tv Series Detail', () {
    final tId = 1;
    final tTvSeriesResponse = TvSeriesDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      id: 1,
      originalName: 'originalName',
      overview: 'overview',
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      name: 'name',
      voteAverage: 1.0,
      voteCount: 1,
      genres: [GenreModel(id: 1, name: 'Action')],
      numberOfEpisodes: 10,
      numberOfSeasons: 2,
    );

    test(
      'should return tv serial data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(tId),
        ).thenAnswer((_) async => tTvSeriesResponse);
        // act
        final result = await repository.getTvSeriesDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesDetail(tId));
        expect(result, equals(Right(testTvSeriesDetail)));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvSeriesDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesDetail(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvSeriesDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesDetail(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Get Tv Series Recommendations', () {
    final tTvSeriesList = <TvSeriesModel>[];
    final tId = 1;

    test(
      'should return data (tv series list) when the call is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesRecommendation(tId),
        ).thenAnswer((_) async => tTvSeriesList);
        // act
        final result = await repository.getTvSeriesRecommendation(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesRecommendation(tId));
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tTvSeriesList));
      },
    );

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesRecommendation(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvSeriesRecommendation(tId);
        // assertbuild runner
        verify(mockRemoteDataSource.getTvSeriesRecommendation(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesRecommendation(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvSeriesRecommendation(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesRecommendation(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Seach Tv Series', () {
    final tQuery = 'breaking bad';

    test(
      'should return tv series list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvSeries(tQuery),
        ).thenAnswer((_) async => tTvSeriesModelList);
        // act
        final result = await repository.searchTvSeries(tQuery);
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvSeries(tQuery),
        ).thenThrow(ServerException());
        // act
        final result = await repository.searchTvSeries(tQuery);
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvSeries(tQuery),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchTvSeries(tQuery);
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('save tv series watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlist(testTvSeriesTable),
      ).thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlist(testTvSeriesTable),
      ).thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove tv series watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlist(testTvSeriesTable),
      ).thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlist(testTvSeriesTable),
      ).thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get tv series watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(
        mockLocalDataSource.getTvSeriesById(tId),
      ).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get tv series watchlist movies', () {
    test('should return list of Tv Series', () async {
      // arrange
      when(
        mockLocalDataSource.getWatchlistTvSeries(),
      ).thenAnswer((_) async => [testTvSeriesTable]);
      // act
      final result = await repository.getWatchListTvSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvSeries]);
    });
  });
}

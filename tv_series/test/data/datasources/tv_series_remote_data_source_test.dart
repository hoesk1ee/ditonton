import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../../../core/test/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing Tv Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/on_the_air.json')),
    ).tvSeriesList;

    test(
      'should return list of Tv Series Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/on_the_air.json'), 200),
        );
        // act
        final result = await dataSource.getOnTheAirTvSeries();
        // assert
        expect(result, equals(tTvSeriesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getOnTheAirTvSeries();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular Tv Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/popular_tv_series.json')),
    ).tvSeriesList;

    test(
      'should return list of tv series when response is success (200)',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/popular_tv_series.json'), 200),
        );
        // act
        final result = await dataSource.getPopularTvSeries();
        // assert
        expect(result, tTvSeriesList);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getPopularTvSeries();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated Tv Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/top_rated_tv_series.json')),
    ).tvSeriesList;

    test(
      'should return list of tv series when response code is 200 ',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/top_rated_tv_series.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getTopRatedTvSeries();
        // assert
        expect(result, tTvSeriesList);
      },
    );

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTopRatedTvSeries();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv series detail', () {
    final tId = 1;
    final tTvSeriesDetail = TvSeriesDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_detail.json')),
    );

    test(
      'should return tv series detail when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_series_detail.json'), 200),
        );
        // act
        final result = await dataSource.getTvSeriesDetail(tId);
        // assert
        expect(result, equals(tTvSeriesDetail));
      },
    );

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvSeriesDetail(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv series recommendations', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_recommendations.json')),
    ).tvSeriesList;
    final tId = 1;

    test(
      'should return list of tv series Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_series_recommendations.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getTvSeriesRecommendation(tId);
        // assert
        expect(result, equals(tTvSeriesList));
      },
    );

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvSeriesRecommendation(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search tv series', () {
    final tSearchResult = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/search_breaking_bad_tv_series.json')),
    ).tvSeriesList;
    final tQuery = 'Breaking Bad';

    test('should return list of tv series when response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/search_breaking_bad_tv_series.json'),
          200,
        ),
      );
      // act
      final result = await dataSource.searchTvSeries(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.searchTvSeries(tQuery);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}

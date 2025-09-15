import 'package:core/data/models/tv_series_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:core/domain/entities/tv_series_detail.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: 'Action');

  final tTvSeriesDetailResponse = TvSeriesDetailResponse(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [tGenreModel],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    posterPath: 'posterPath',
    firstAirDate: '2023-01-01',
    numberOfEpisodes: 10,
    numberOfSeasons: 2,
    name: 'name',
    voteAverage: 8.5,
    voteCount: 100,
  );

  final tTvSeriesDetailResponseJson = {
    "adult": false,
    "backdrop_path": 'backdropPath',
    "genres": [
      {"id": 1, "name": "Action"}
    ],
    "id": 1,
    "original_name": 'originalName',
    "overview": 'overview',
    "poster_path": 'posterPath',
    "first_air_date": '2023-01-01',
    "number_of_episodes": 10,
    "number_of_seasons": 2,
    "name": 'name',
    "vote_average": 8.5,
    "vote_count": 100,
  };

  group('TvSeriesDetailResponse', () {
    test('fromJson should return valid model', () {
      final result =
          TvSeriesDetailResponse.fromJson(tTvSeriesDetailResponseJson);
      expect(result, tTvSeriesDetailResponse);
    });

    test('toJson should return proper map', () {
      final result = tTvSeriesDetailResponse.toJson();
      expect(result, tTvSeriesDetailResponseJson);
    });

    test('toEntity should return proper entity', () {
      final result = tTvSeriesDetailResponse.toEntity();
      final tTvSeriesDetail = TvSeriesDetail(
        adult: false,
        backdropPath: 'backdropPath',
        genres: [tGenreModel.toEntity()],
        id: 1,
        originalName: 'originalName',
        overview: 'overview',
        posterPath: 'posterPath',
        firstAirDate: '2023-01-01',
        numberOfEpisodes: 10,
        numberOfSeasons: 2,
        name: 'name',
        voteAverage: 8.5,
        voteCount: 100,
      );
      expect(result, tTvSeriesDetail);
    });
  });
}

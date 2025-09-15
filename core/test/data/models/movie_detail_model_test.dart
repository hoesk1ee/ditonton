import 'package:core/data/models/movie_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:core/domain/entities/movie_detail.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: 'Action');

  final tMovieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: 'backdropPath',
    budget: 1000,
    genres: [tGenreModel],
    homepage: 'homepage',
    id: 1,
    imdbId: 'imdbId',
    originalLanguage: 'en',
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    releaseDate: '2023-01-01',
    revenue: 5000,
    runtime: 120,
    status: 'Released',
    tagline: 'tagline',
    title: 'title',
    video: false,
    voteAverage: 8.5,
    voteCount: 100,
  );

  final tMovieDetailResponseJson = {
    "adult": false,
    "backdrop_path": 'backdropPath',
    "budget": 1000,
    "genres": [
      {"id": 1, "name": "Action"}
    ],
    "homepage": 'homepage',
    "id": 1,
    "imdb_id": 'imdbId',
    "original_language": 'en',
    "original_title": 'originalTitle',
    "overview": 'overview',
    "popularity": 1.0,
    "poster_path": 'posterPath',
    "release_date": '2023-01-01',
    "revenue": 5000,
    "runtime": 120,
    "status": 'Released',
    "tagline": 'tagline',
    "title": 'title',
    "video": false,
    "vote_average": 8.5,
    "vote_count": 100,
  };

  group('MovieDetailResponse', () {
    test('fromJson should return valid model', () {
      final result = MovieDetailResponse.fromJson(tMovieDetailResponseJson);
      expect(result, tMovieDetailResponse);
    });

    test('toJson should return proper map', () {
      final result = tMovieDetailResponse.toJson();
      expect(result, tMovieDetailResponseJson);
    });

    test('toEntity should return proper entity', () {
      final result = tMovieDetailResponse.toEntity();
      final tMovieDetail = MovieDetail(
        adult: false,
        backdropPath: 'backdropPath',
        genres: [tGenreModel.toEntity()],
        id: 1,
        originalTitle: 'originalTitle',
        overview: 'overview',
        posterPath: 'posterPath',
        releaseDate: '2023-01-01',
        runtime: 120,
        title: 'title',
        voteAverage: 8.5,
        voteCount: 100,
      );
      expect(result, tMovieDetail);
    });
  });
}

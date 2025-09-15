import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:core/domain/entities/genre.dart';

void main() {
  group('GenreModel', () {
    final tGenreModel = GenreModel(id: 1, name: 'Action');
    final tGenre = Genre(id: 1, name: 'Action');
    final tJson = {
      "id": 1,
      "name": "Action",
    };

    test('should be a subclass of Equatable', () async {
      expect(tGenreModel.props, [1, 'Action']);
    });

    test('fromJson should return valid model', () async {
      final result = GenreModel.fromJson(tJson);
      expect(result, tGenreModel);
    });

    test('toJson should return proper map', () async {
      final result = tGenreModel.toJson();
      expect(result, tJson);
    });

    test('toEntity should return proper entity', () async {
      final result = tGenreModel.toEntity();
      expect(result, tGenre);
    });
  });
}

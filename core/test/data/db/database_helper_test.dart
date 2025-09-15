import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/models/movie_table.dart';
import 'package:core/data/models/tv_series_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DatabaseHelper databaseHelper;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 3,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE watchlist (
              id INTEGER PRIMARY KEY,
              title TEXT,
              overview TEXT,
              posterPath TEXT
            );
          ''');

          await db.execute('''
            CREATE TABLE tvSeriesWatchlist (
              id INTEGER PRIMARY KEY,
              name TEXT,
              overview TEXT,
              posterPath TEXT
            );
          ''');
        },
      ),
    );

    databaseHelper = DatabaseHelper(testDb: db);
  });

  test('should initialize database and create tables', () async {
    final helper = DatabaseHelper();

    final db = await helper.database;

    expect(db, isNotNull);

    final tables = await db!.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name IN ('watchlist','tvSeriesWatchlist')");
    expect(tables.length, 2);

    final watchlistColumns = await db.rawQuery("PRAGMA table_info(watchlist)");
    final columnNames = watchlistColumns.map((c) => c['name']).toList();
    expect(columnNames, containsAll(['id', 'title', 'overview', 'posterPath']));

    final tvColumns = await db.rawQuery("PRAGMA table_info(tvSeriesWatchlist)");
    final tvColumnNames = tvColumns.map((c) => c['name']).toList();
    expect(
        tvColumnNames, containsAll(['id', 'name', 'overview', 'posterPath']));
  });

  group('Movie Watchlist', () {
    final tMovie = MovieTable(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'title',
      posterPath: 'posterPath',
      overview: 'overview',
    );

    test('should insert and get movie by id', () async {
      await databaseHelper.insertWatchlist(tMovie);

      final result = await databaseHelper.getMovieById(tMovie.id);
      expect(result?['id'], tMovie.id);
      expect(result?['title'], tMovie.title);
    });

    test('should get all watchlist movies', () async {
      await databaseHelper.insertWatchlist(tMovie);

      final result = await databaseHelper.getWatchlistMovies();
      expect(result.length, 1);
      expect(result.first['id'], tMovie.id);
    });

    test('should remove movie from watchlist', () async {
      await databaseHelper.insertWatchlist(tMovie);

      await databaseHelper.removeWatchlist(tMovie);
      final result = await databaseHelper.getWatchlistMovies();

      expect(result.isEmpty, true);
    });
  });

  group('TV Series Watchlist', () {
    final tTv = TvSeriesTable(
      id: 99,
      name: 'name',
      overview: 'overview',
      posterPath: 'poster.png',
    );

    test('should insert and get tv series by id', () async {
      await databaseHelper.insertTvSeriesWatchList(tTv);

      final result = await databaseHelper.getTvSerialById(tTv.id);
      expect(result?['id'], tTv.id);
      expect(result?['name'], tTv.name);
    });

    test('should get all watchlist tv series', () async {
      await databaseHelper.insertTvSeriesWatchList(tTv);

      final result = await databaseHelper.getWatchlistTvSeries();
      expect(result.length, 1);
      expect(result.first['id'], tTv.id);
    });

    test('should remove tv series from watchlist', () async {
      await databaseHelper.insertTvSeriesWatchList(tTv);

      await databaseHelper.removeTvSeriesWatchlist(tTv);
      final result = await databaseHelper.getWatchlistTvSeries();

      expect(result.isEmpty, true);
    });
  });
}

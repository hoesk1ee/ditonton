import 'dart:async';

import 'package:core/data/models/movie_table.dart';
import 'package:core/data/models/tv_series_table.dart';
import 'package:core/utils/common.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance({Database? testDb}) {
    _databaseHelper = this;
    if (testDb != null) {
      _database = testDb;
    }
  }

  factory DatabaseHelper({Database? testDb}) =>
      _databaseHelper ?? DatabaseHelper._instance(testDb: testDb);

  // factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';
  static const String _tblTvSeriesWatchlist = 'tvSeriesWatchlist';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(
      databasePath,
      version: 3,
      onCreate: _onCreate,
      password: encrypt("Your secure password..."),
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE $_tblTvSeriesWatchlist (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  // * TV SERIES WATCHLIST
  Future<int> insertTvSeriesWatchList(TvSeriesTable tvSerial) async {
    final db = await database;
    return await db!.insert(
      _tblTvSeriesWatchlist,
      tvSerial.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> removeTvSeriesWatchlist(TvSeriesTable tvSerial) async {
    final db = await database;
    return await db!.delete(
      _tblTvSeriesWatchlist,
      where: 'id = ?',
      whereArgs: [tvSerial.id],
    );
  }

  Future<Map<String, dynamic>?> getTvSerialById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblTvSeriesWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvSeries() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblTvSeriesWatchlist,
    );

    return results;
  }

  // * MOVIE WATCHLIST
  Future<int> insertWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.insert(
      _tblWatchlist,
      movie.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> removeWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlist);

    return results;
  }
}

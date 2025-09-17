import 'dart:async';

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

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String tblWatchlist = 'watchlist';
  static const String tblTvSeriesWatchlist = 'tvSeriesWatchlist';

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
      CREATE TABLE  $tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE $tblTvSeriesWatchlist (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return db!.insert(
      table,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(String table, int id) async {
    final db = await database;
    return db!.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getById(String table, int id) async {
    final db = await database;
    final results = await db!.query(table, where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await database;
    return db!.query(table);
  }

  // // * TV SERIES WATCHLIST
  // Future<int> insertTvSeriesWatchList(TvSeriesTable tvSerial) async {
  //   final db = await database;
  //   return await db!.insert(
  //     _tblTvSeriesWatchlist,
  //     tvSerial.toJson(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // Future<int> removeTvSeriesWatchlist(TvSeriesTable tvSerial) async {
  //   final db = await database;
  //   return await db!.delete(
  //     _tblTvSeriesWatchlist,
  //     where: 'id = ?',
  //     whereArgs: [tvSerial.id],
  //   );
  // }

  // Future<Map<String, dynamic>?> getTvSerialById(int id) async {
  //   final db = await database;
  //   final results = await db!.query(
  //     _tblTvSeriesWatchlist,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );

  //   if (results.isNotEmpty) {
  //     return results.first;
  //   } else {
  //     return null;
  //   }
  // }

  // Future<List<Map<String, dynamic>>> getWatchlistTvSeries() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> results = await db!.query(
  //     _tblTvSeriesWatchlist,
  //   );

  //   return results;
  // }

  // // * MOVIE WATCHLIST
  // Future<int> insertWatchlist(MovieTable movie) async {
  //   final db = await database;
  //   return await db!.insert(
  //     _tblWatchlist,
  //     movie.toJson(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // Future<int> removeWatchlist(MovieTable movie) async {
  //   final db = await database;
  //   return await db!.delete(
  //     _tblWatchlist,
  //     where: 'id = ?',
  //     whereArgs: [movie.id],
  //   );
  // }

  // Future<Map<String, dynamic>?> getMovieById(int id) async {
  //   final db = await database;
  //   final results = await db!.query(
  //     _tblWatchlist,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );

  //   if (results.isNotEmpty) {
  //     return results.first;
  //   } else {
  //     return null;
  //   }
  // }

  // Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> results = await db!.query(_tblWatchlist);

  //   return results;
  // }
}

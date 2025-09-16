import 'package:core/core.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/models/tv_series_table.dart';

abstract class TvSeriesLocalDataSource {
  Future<String> insertWatchlist(TvSeriesTable tvSerial);
  Future<String> removeWatchlist(TvSeriesTable tvSerial);
  Future<TvSeriesTable?> getTvSeriesById(int id);
  Future<List<TvSeriesTable>> getWatchlistTvSeries();
}

class TvSeriesLocalDataSourceImpl implements TvSeriesLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvSeriesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(TvSeriesTable tvSerial) async {
    try {
      await databaseHelper.insert(
        DatabaseHelper.tblTvSeriesWatchlist,
        tvSerial.toJson(),
      );
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvSeriesTable?> getTvSeriesById(int id) async {
    final result = await databaseHelper.getById(
      DatabaseHelper.tblTvSeriesWatchlist,
      id,
    );
    if (result != null) {
      return TvSeriesTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvSeriesTable>> getWatchlistTvSeries() async {
    final result = await databaseHelper.getAll(
      DatabaseHelper.tblTvSeriesWatchlist,
    );
    return result.map((data) => TvSeriesTable.fromMap(data)).toList();
  }

  @override
  Future<String> removeWatchlist(TvSeriesTable tvSerial) async {
    try {
      await databaseHelper.delete(
        DatabaseHelper.tblTvSeriesWatchlist,
        tvSerial.id,
      );
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}

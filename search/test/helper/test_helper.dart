import 'package:core/data/datasources/db/database_helper.dart';

import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';

@GenerateMocks(
  [
    MovieRepository,
    MovieRemoteDataSource,
    MovieLocalDataSource,

    TvSeriesRepository,
    TvSeriesRemoteDataSource,
    TvSeriesLocalDataSource,

    DatabaseHelper,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}

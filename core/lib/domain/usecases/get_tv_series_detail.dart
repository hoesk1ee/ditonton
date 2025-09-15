import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:core/core.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';

// ! TASK 4: Create usecase
class GetTvSeriesDetail {
  final TvSeriesRepository repository;

  GetTvSeriesDetail(this.repository);

  Future<Either<Failure, TvSeriesDetail>> execute(int id) {
    return repository.getTvSeriesDetail(id);
  }
}

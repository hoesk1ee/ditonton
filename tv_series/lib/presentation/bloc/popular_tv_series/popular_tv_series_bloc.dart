import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

part 'popular_tv_series_event.dart';
part 'popular_tv_series_state.dart';

class PopularTvSeriesBloc
    extends Bloc<PopularTvSeriesEvent, PopularTvSeriesState> {
  final GetPopularTvSeries _getPopularTvSeries;

  PopularTvSeriesBloc(this._getPopularTvSeries)
    : super(PopularTvSeriesInitial()) {
    on<FetchPopularTvSeries>((event, emit) async {
      emit(PopularTvSeriesLoading());

      final result = await _getPopularTvSeries.execute();

      result.fold(
        (failure) {
          emit(PopularTvSeriesHasError("Server Failure"));
        },
        (data) {
          if (data.isEmpty) {
            emit(PopularTvSeriesEmpty("No popular movie found"));
          } else {
            emit(PopularTvSeriesHasData(data));
          }
        },
      );
    });
  }
}

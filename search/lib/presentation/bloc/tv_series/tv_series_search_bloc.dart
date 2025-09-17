import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/search.dart';
import 'package:search/utils/debouce_event_transformer.dart';
import 'package:tv_series/tv_series.dart';

part 'tv_series_search_event.dart';
part 'tv_series_search_state.dart';

class TvSeriesSearchBloc
    extends Bloc<TvSeriesSearchEvent, TvSeriesSearchState> {
  final SearchTvSeries _searchTvSeries;

  TvSeriesSearchBloc(this._searchTvSeries) : super(TvSeriesSearchInitial()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(TvSeriesSearchLoading());
      final result = await _searchTvSeries.execute(query);

      result.fold(
        (failure) {
          emit(TvSeriesSearchHasError(failure.message));
        },
        (data) {
          if (data.isEmpty) {
            emit(TvSeriesSearchEmpty("No TV series found"));
          } else {
            emit(TvSeriesSearchHasData(data));
          }
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}

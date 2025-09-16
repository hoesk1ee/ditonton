import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:search/search.dart';
import 'package:search/utils/debouce_event_transformer.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies _searchMovies;

  SearchBloc(this._searchMovies) : super(SearchInitial()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchLoading());
      final result = await _searchMovies.execute(query);

      result.fold(
        (failure) {
          emit(SearchError("Server Failure"));
        },
        (data) {
          if (data.isEmpty) {
            emit(SearchEmpty("No Movie found"));
          } else {
            emit(SearchHasData(data));
          }
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}

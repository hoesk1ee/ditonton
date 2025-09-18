import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  WatchlistMoviesBloc() : super(WatchlistMoviesInitial()) {
    on<WatchlistMoviesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

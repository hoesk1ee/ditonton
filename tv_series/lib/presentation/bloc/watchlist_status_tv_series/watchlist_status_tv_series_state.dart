part of 'watchlist_status_tv_series_bloc.dart';

class WatchlistStatusTvSeriesState extends Equatable {
  final bool isAdded;
  final String message;

  const WatchlistStatusTvSeriesState({this.isAdded = false, this.message = ""});

  WatchlistStatusTvSeriesState copyWith({bool? isAdded, String? message}) {
    return WatchlistStatusTvSeriesState(
      isAdded: isAdded ?? this.isAdded,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [isAdded, message];
}

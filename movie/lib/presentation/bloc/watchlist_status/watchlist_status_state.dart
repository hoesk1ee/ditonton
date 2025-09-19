part of 'watchlist_status_bloc.dart';

class WatchlistStatusState extends Equatable {
  final bool isAdded;
  final String message;

  const WatchlistStatusState({this.isAdded = false, this.message = ""});

  WatchlistStatusState copyWith({bool? isAdded, String? message}) {
    return WatchlistStatusState(
      isAdded: isAdded ?? this.isAdded,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [isAdded, message];
}

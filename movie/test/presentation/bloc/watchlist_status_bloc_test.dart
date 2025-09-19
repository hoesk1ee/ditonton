import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';

import 'watchlist_status_bloc_test.mocks.dart';

@GenerateMocks([GetWatchListStatus, RemoveWatchlist, SaveWatchlist])
void main() {
  late WatchlistStatusBloc watchlistStatusBloc;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MockSaveWatchlist mockSaveWatchlist;

  const tMovieId = 1;
  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockSaveWatchlist = MockSaveWatchlist();
    watchlistStatusBloc = WatchlistStatusBloc(
      mockSaveWatchlist,
      mockRemoveWatchlist,
      mockGetWatchListStatus,
    );
  });

  test("Initial state should be default/empty", () {
    const state = WatchlistStatusState();
    expect(state.isAdded, false);
    expect(state.message, "");
  });

  blocTest<WatchlistStatusBloc, WatchlistStatusState>(
    'emits [isAdded true] when GetMovieWatchlistStatus returns true',
    build: () {
      when(
        mockGetWatchListStatus.execute(tMovieId),
      ).thenAnswer((_) async => true);
      return watchlistStatusBloc;
    },
    act: (bloc) => bloc.add(GetMovieWatchlistStatus(tMovieId)),
    expect: () => [const WatchlistStatusState(isAdded: true, message: '')],
  );

  blocTest<WatchlistStatusBloc, WatchlistStatusState>(
    'emits [isAdded true, message success] when AddMovieToWatchlist success',
    build: () {
      when(
        mockSaveWatchlist.execute(tMovieDetail),
      ).thenAnswer((_) async => const Right('Added to Watchlist'));
      when(
        mockGetWatchListStatus.execute(tMovieDetail.id),
      ).thenAnswer((_) async => true);
      return watchlistStatusBloc;
    },
    act: (bloc) => bloc.add(AddMovieToWatchlist(tMovieDetail)),
    expect: () => [
      const WatchlistStatusState(isAdded: true, message: 'Added to Watchlist'),
    ],
  );

  blocTest<WatchlistStatusBloc, WatchlistStatusState>(
    'emits [isAdded false, message failure] when AddMovieToWatchlist failed',
    build: () {
      when(
        mockSaveWatchlist.execute(tMovieDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure('Failed to add')));

      when(
        mockGetWatchListStatus.execute(tMovieDetail.id),
      ).thenAnswer((_) async => false);

      return watchlistStatusBloc;
    },
    act: (bloc) => bloc.add(AddMovieToWatchlist(tMovieDetail)),
    expect: () => [
      const WatchlistStatusState(isAdded: false, message: 'Failed to add'),
    ],
  );

  blocTest<WatchlistStatusBloc, WatchlistStatusState>(
    'emits [isAdded false, message success] when RemoveMovieFromWatchlist success',
    build: () {
      when(
        mockRemoveWatchlist.execute(tMovieDetail),
      ).thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(
        mockGetWatchListStatus.execute(tMovieDetail.id),
      ).thenAnswer((_) async => false);
      return watchlistStatusBloc;
    },
    act: (bloc) => bloc.add(RemoveMovieFromWatchlist(tMovieDetail)),
    expect: () => [
      const WatchlistStatusState(
        isAdded: false,
        message: 'Removed from Watchlist',
      ),
    ],
  );

  blocTest<WatchlistStatusBloc, WatchlistStatusState>(
    'emits [isAdded false, message failure] when RemoveMovieFromWatchlist failed',
    build: () {
      when(
        mockRemoveWatchlist.execute(tMovieDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure('Failed to remove')));

      when(
        mockGetWatchListStatus.execute(tMovieDetail.id),
      ).thenAnswer((_) async => false);

      return watchlistStatusBloc;
    },
    act: (bloc) => bloc.add(RemoveMovieFromWatchlist(tMovieDetail)),
    expect: () => [
      const WatchlistStatusState(isAdded: false, message: 'Failed to remove'),
    ],
  );
}

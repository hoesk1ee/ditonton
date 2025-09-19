import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/presentation/bloc/watchlist_status_tv_series/watchlist_status_tv_series_bloc.dart';
import 'package:tv_series/tv_series.dart';

import 'watchlist_status_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTvSeriesStatus,
  RemoveTvSeriesWatchlist,
  SaveTvSeriesWatchlist,
])
void main() {
  late WatchlistStatusTvSeriesBloc watchlistStatusTvSeriesBloc;
  late MockGetWatchlistTvSeriesStatus mockGetWatchlistTvSeriesStatus;
  late MockRemoveTvSeriesWatchlist mockRemoveTvSeriesWatchlist;
  late MockSaveTvSeriesWatchlist mockSaveTvSeriesWatchlist;

  const tTvSeriesId = 1;
  final tTvSeriesDetail = TvSeriesDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    numberOfEpisodes: 10,
    numberOfSeasons: 2,
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

  setUp(() {
    mockGetWatchlistTvSeriesStatus = MockGetWatchlistTvSeriesStatus();
    mockRemoveTvSeriesWatchlist = MockRemoveTvSeriesWatchlist();
    mockSaveTvSeriesWatchlist = MockSaveTvSeriesWatchlist();
    watchlistStatusTvSeriesBloc = WatchlistStatusTvSeriesBloc(
      mockSaveTvSeriesWatchlist,
      mockRemoveTvSeriesWatchlist,
      mockGetWatchlistTvSeriesStatus,
    );
  });

  test("Initial state should be default/empty", () {
    const state = WatchlistStatusTvSeriesState();
    expect(state.isAdded, false);
    expect(state.message, "");
  });

  blocTest<WatchlistStatusTvSeriesBloc, WatchlistStatusTvSeriesState>(
    'emits [isAdded true] when get tv series watchlist status returns true',
    build: () {
      when(
        mockGetWatchlistTvSeriesStatus.execute(tTvSeriesId),
      ).thenAnswer((_) async => true);
      return watchlistStatusTvSeriesBloc;
    },
    act: (bloc) => bloc.add(GetTvSeriesWatchlistStatus(tTvSeriesId)),
    expect: () => [
      const WatchlistStatusTvSeriesState(isAdded: true, message: ''),
    ],
  );

  blocTest<WatchlistStatusTvSeriesBloc, WatchlistStatusTvSeriesState>(
    'emits [isAdded true, message success] when add tv series to watchlist success',
    build: () {
      when(
        mockSaveTvSeriesWatchlist.execute(tTvSeriesDetail),
      ).thenAnswer((_) async => const Right('Added to Watchlist'));
      when(
        mockGetWatchlistTvSeriesStatus.execute(tTvSeriesDetail.id),
      ).thenAnswer((_) async => true);
      return watchlistStatusTvSeriesBloc;
    },
    act: (bloc) => bloc.add(AddTvSeriesToWatchlist(tTvSeriesDetail)),
    expect: () => [
      const WatchlistStatusTvSeriesState(
        isAdded: true,
        message: 'Added to Watchlist',
      ),
    ],
  );

  blocTest<WatchlistStatusTvSeriesBloc, WatchlistStatusTvSeriesState>(
    'emits [isAdded false, message failure] when add tv series to watchlist failed',
    build: () {
      when(
        mockSaveTvSeriesWatchlist.execute(tTvSeriesDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure('Failed to add')));

      when(
        mockGetWatchlistTvSeriesStatus.execute(tTvSeriesDetail.id),
      ).thenAnswer((_) async => false);

      return watchlistStatusTvSeriesBloc;
    },
    act: (bloc) => bloc.add(AddTvSeriesToWatchlist(tTvSeriesDetail)),
    expect: () => [
      const WatchlistStatusTvSeriesState(
        isAdded: false,
        message: 'Failed to add',
      ),
    ],
  );

  blocTest<WatchlistStatusTvSeriesBloc, WatchlistStatusTvSeriesState>(
    'emits [isAdded false, message success] when remove tv series from watchlist success',
    build: () {
      when(
        mockRemoveTvSeriesWatchlist.execute(tTvSeriesDetail),
      ).thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(
        mockGetWatchlistTvSeriesStatus.execute(tTvSeriesDetail.id),
      ).thenAnswer((_) async => false);
      return watchlistStatusTvSeriesBloc;
    },
    act: (bloc) => bloc.add(RemoveTvSeriesFromWatchlist(tTvSeriesDetail)),
    expect: () => [
      const WatchlistStatusTvSeriesState(
        isAdded: false,
        message: 'Removed from Watchlist',
      ),
    ],
  );

  blocTest<WatchlistStatusTvSeriesBloc, WatchlistStatusTvSeriesState>(
    'emits [isAdded false, message failure] when remove tv series from watchlist failed',
    build: () {
      when(
        mockRemoveTvSeriesWatchlist.execute(tTvSeriesDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure('Failed to remove')));

      when(
        mockGetWatchlistTvSeriesStatus.execute(tTvSeriesDetail.id),
      ).thenAnswer((_) async => false);

      return watchlistStatusTvSeriesBloc;
    },
    act: (bloc) => bloc.add(RemoveTvSeriesFromWatchlist(tTvSeriesDetail)),
    expect: () => [
      const WatchlistStatusTvSeriesState(
        isAdded: false,
        message: 'Failed to remove',
      ),
    ],
  );
}

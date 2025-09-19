import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_status_tv_series/watchlist_status_tv_series_bloc.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';

// * Create manual mock
class MockTvSeriesDetailBloc extends Mock implements TvSeriesDetailBloc {}

class MockWatchlistTvSeriesStatusBloc extends Mock
    implements WatchlistStatusTvSeriesBloc {}

void main() {
  late MockTvSeriesDetailBloc mockBloc;
  late MockWatchlistTvSeriesStatusBloc mockStatus;

  setUpAll(() {
    // * Register fallback for mocktail.
    registerFallbackValue(TvSeriesDetailInitial());
    registerFallbackValue(
      const WatchlistStatusTvSeriesState(isAdded: false, message: ''),
    );
  });

  setUp(() {
    mockBloc = MockTvSeriesDetailBloc();
    mockStatus = MockWatchlistTvSeriesStatusBloc();

    // * Default stub for TvSeries bloc
    when(() => mockBloc.state).thenReturn(TvSeriesDetailLoading());
    when(() => mockBloc.stream).thenAnswer(
      (_) =>
          Stream<TvSeriesDetailState>.fromIterable([TvSeriesDetailLoading()]),
    );

    // * Default stub for status bloc
    when(() => mockStatus.state).thenReturn(
      const WatchlistStatusTvSeriesState(isAdded: false, message: ''),
    );
    when(
      () => mockStatus.stream,
    ).thenAnswer((_) => Stream<WatchlistStatusTvSeriesState>.empty());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvSeriesDetailBloc>.value(value: mockBloc),
        BlocProvider<WatchlistStatusTvSeriesBloc>.value(value: mockStatus),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when TvSeries not added to watchlist',
    (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(TvSeriesDetailHasData(testTvSeriesDetail, <TvSeries>[]));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          TvSeriesDetailHasData(testTvSeriesDetail, <TvSeries>[]),
        ]),
      );
      when(() => mockStatus.state).thenReturn(
        const WatchlistStatusTvSeriesState(isAdded: false, message: ''),
      );
      when(() => mockStatus.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const WatchlistStatusTvSeriesState(isAdded: false, message: ''),
        ]),
      );

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);
    },
  );

  testWidgets(
    'should display CircularProgressIndicator when TvSeriesState is Loading',
    (tester) async {
      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('should display error message when TvSeriesState is Error', (
    tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(TvSeriesDetailHasError('Error Message'));
    whenListen(
      mockBloc,
      Stream.fromIterable([TvSeriesDetailHasError('Error Message')]),
    );

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
    expect(find.text('Error Message'), findsOneWidget);
  });

  testWidgets(
    'should display CircularProgressIndicator when recommendationState is Loading',
    (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(TvSeriesDetailHasData(testTvSeriesDetail, <TvSeries>[]));
      whenListen(
        mockBloc,
        Stream.fromIterable([
          TvSeriesDetailHasData(testTvSeriesDetail, <TvSeries>[]),
        ]),
      );

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    },
  );

  testWidgets(
    'should display error message when recommendationState is Error',
    (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(TvSeriesDetailHasError('Recommendation Error'));
      whenListen(
        mockBloc,
        Stream.fromIterable([TvSeriesDetailHasError('Recommendation Error')]),
      );

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
      expect(find.text('Recommendation Error'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when TvSeries is added to watchlist',
    (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(TvSeriesDetailHasData(testTvSeriesDetail, <TvSeries>[]));
      whenListen(
        mockBloc,
        Stream.fromIterable([
          TvSeriesDetailHasData(testTvSeriesDetail, <TvSeries>[]),
        ]),
      );
      when(() => mockStatus.state).thenReturn(
        const WatchlistStatusTvSeriesState(isAdded: true, message: ''),
      );
      whenListen(
        mockStatus,
        Stream.fromIterable([
          const WatchlistStatusTvSeriesState(isAdded: true, message: ''),
        ]),
      );

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
      expect(find.byIcon(Icons.check), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(TvSeriesDetailHasData(testTvSeriesDetail, <TvSeries>[]));
      whenListen(
        mockBloc,
        Stream.fromIterable([
          TvSeriesDetailHasData(testTvSeriesDetail, <TvSeries>[]),
        ]),
      );
      when(() => mockStatus.state).thenReturn(
        const WatchlistStatusTvSeriesState(
          isAdded: false,
          message: 'Added to Watchlist',
        ),
      );
      whenListen(
        mockStatus,
        Stream.fromIterable([
          const WatchlistStatusTvSeriesState(
            isAdded: false,
            message: 'Added to Watchlist',
          ),
        ]),
      );

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display SnackBar when add to watchlist failed',
    (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(TvSeriesDetailHasData(testTvSeriesDetail, <TvSeries>[]));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          TvSeriesDetailHasData(testTvSeriesDetail, <TvSeries>[]),
        ]),
      );

      when(() => mockStatus.state).thenReturn(
        const WatchlistStatusTvSeriesState(isAdded: false, message: ''),
      );

      whenListen(
        mockStatus,
        Stream.fromIterable([
          const WatchlistStatusTvSeriesState(isAdded: false, message: ''),
          const WatchlistStatusTvSeriesState(isAdded: false, message: 'Failed'),
        ]),
      );

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';

// * Create manual mock
class MockMovieDetailBloc extends Mock implements MovieDetailBloc {}

class MockWatchlistStatusBloc extends Mock implements WatchlistStatusBloc {}

void main() {
  late MockMovieDetailBloc mockBloc;
  late MockWatchlistStatusBloc mockStatus;

  setUpAll(() {
    // * Register fallback for mocktail.
    registerFallbackValue(MovieDetailInitial());
    registerFallbackValue(
      const WatchlistStatusState(isAdded: false, message: ''),
    );
  });

  setUp(() {
    mockBloc = MockMovieDetailBloc();
    mockStatus = MockWatchlistStatusBloc();

    // * Default stub for movie bloc
    when(() => mockBloc.state).thenReturn(MovieDetailLoading());
    when(() => mockBloc.stream).thenAnswer(
      (_) => Stream<MovieDetailState>.fromIterable([MovieDetailLoading()]),
    );

    // * Default stub for status bloc
    when(
      () => mockStatus.state,
    ).thenReturn(const WatchlistStatusState(isAdded: false, message: ''));
    when(
      () => mockStatus.stream,
    ).thenAnswer((_) => Stream<WatchlistStatusState>.empty());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(value: mockBloc),
        BlocProvider<WatchlistStatusBloc>.value(value: mockStatus),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(MovieDetailHasData(testMovieDetail, <Movie>[]));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          MovieDetailHasData(testMovieDetail, <Movie>[]),
        ]),
      );
      when(
        () => mockStatus.state,
      ).thenReturn(const WatchlistStatusState(isAdded: false, message: ''));
      when(() => mockStatus.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const WatchlistStatusState(isAdded: false, message: ''),
        ]),
      );

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);
    },
  );

  testWidgets(
    'should display CircularProgressIndicator when movieState is Loading',
    (tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('should display error message when movieState is Error', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(MovieDetailHasError('Error Message'));
    whenListen(
      mockBloc,
      Stream.fromIterable([MovieDetailHasError('Error Message')]),
    );

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    expect(find.text('Error Message'), findsOneWidget);
  });

  testWidgets(
    'should display CircularProgressIndicator when recommendationState is Loading',
    (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(MovieDetailHasData(testMovieDetail, <Movie>[]));
      whenListen(
        mockBloc,
        Stream.fromIterable([MovieDetailHasData(testMovieDetail, <Movie>[])]),
      );

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    },
  );

  testWidgets(
    'should display error message when recommendationState is Error',
    (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(MovieDetailHasError('Recommendation Error'));
      whenListen(
        mockBloc,
        Stream.fromIterable([MovieDetailHasError('Recommendation Error')]),
      );

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
      expect(find.text('Recommendation Error'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when movie is added to watchlist',
    (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(MovieDetailHasData(testMovieDetail, <Movie>[]));
      whenListen(
        mockBloc,
        Stream.fromIterable([MovieDetailHasData(testMovieDetail, <Movie>[])]),
      );
      when(
        () => mockStatus.state,
      ).thenReturn(const WatchlistStatusState(isAdded: true, message: ''));
      whenListen(
        mockStatus,
        Stream.fromIterable([
          const WatchlistStatusState(isAdded: true, message: ''),
        ]),
      );

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
      expect(find.byIcon(Icons.check), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(MovieDetailHasData(testMovieDetail, <Movie>[]));
      whenListen(
        mockBloc,
        Stream.fromIterable([MovieDetailHasData(testMovieDetail, <Movie>[])]),
      );
      when(() => mockStatus.state).thenReturn(
        const WatchlistStatusState(
          isAdded: false,
          message: 'Added to Watchlist',
        ),
      );
      whenListen(
        mockStatus,
        Stream.fromIterable([
          const WatchlistStatusState(
            isAdded: false,
            message: 'Added to Watchlist',
          ),
        ]),
      );

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
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
      ).thenReturn(MovieDetailHasData(testMovieDetail, <Movie>[]));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          MovieDetailHasData(testMovieDetail, <Movie>[]),
        ]),
      );

      when(
        () => mockStatus.state,
      ).thenReturn(const WatchlistStatusState(isAdded: false, message: ''));

      whenListen(
        mockStatus,
        Stream.fromIterable([
          const WatchlistStatusState(isAdded: false, message: ''),
          const WatchlistStatusState(isAdded: false, message: 'Failed'),
        ]),
      );

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}

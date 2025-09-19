import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movie/presentation/bloc/popular_movies/popular_movies_bloc.dart';

// * Create manual mock
class MockPopularMoviesBloc extends Mock implements PopularMoviesBloc {}

void main() {
  late MockPopularMoviesBloc mockBloc;

  setUpAll(() {
    // * Register fallback for mocktail.
    registerFallbackValue(PopularMoviesInitial());
  });

  setUp(() {
    mockBloc = MockPopularMoviesBloc();

    // * Default stub for popular movies bloc
    when(() => mockBloc.state).thenReturn(PopularMoviesLoading());
    when(() => mockBloc.stream).thenAnswer(
      (_) => Stream<PopularMoviesState>.fromIterable([PopularMoviesLoading()]),
    );
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
    'should display error message when popular movie state is Error',
    (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(PopularMoviesHasError('Server Failure'));
      whenListen(
        mockBloc,
        Stream.fromIterable([PopularMoviesHasError('Server Failure')]),
      );

      final textFinder = find.byKey(Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));
      expect(textFinder, findsOneWidget);
    },
  );

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(PopularMoviesHasData(<Movie>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });
}

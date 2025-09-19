import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';

// * Create manual mock
class MockTopRatedMoviesBloc extends Mock implements TopRatedMoviesBloc {}

void main() {
  late MockTopRatedMoviesBloc mockBloc;

  setUpAll(() {
    // * Register fallback for mocktail.
    registerFallbackValue(TopRatedMoviesInitial());
  });

  setUp(() {
    mockBloc = MockTopRatedMoviesBloc();

    // * Default stub for top rated movies bloc
    when(() => mockBloc.state).thenReturn(TopRatedMoviesLoading());
    when(() => mockBloc.stream).thenAnswer(
      (_) =>
          Stream<TopRatedMoviesState>.fromIterable([TopRatedMoviesLoading()]),
    );
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
    'should display error message when popular movie state is Error',
    (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(TopRatedMoviesHasError('Server Failure'));
      whenListen(
        mockBloc,
        Stream.fromIterable([TopRatedMoviesHasError('Server Failure')]),
      );

      final textFinder = find.byKey(Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));
      expect(textFinder, findsOneWidget);
    },
  );

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(TopRatedMoviesHasData(<Movie>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tv_series/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:tv_series/tv_series.dart';

// * Create manual mock
class MockTopRatedTvSeriesBloc extends Mock implements TopRatedTvSeriesBloc {}

void main() {
  late MockTopRatedTvSeriesBloc mockBloc;

  setUpAll(() {
    // * Register fallback for mocktail.
    registerFallbackValue(TopRatedTvSeriesInitial());
  });

  setUp(() {
    mockBloc = MockTopRatedTvSeriesBloc();

    // * Default stub for top rated TvSeries bloc
    when(() => mockBloc.state).thenReturn(TopRatedTvSeriesLoading());
    when(() => mockBloc.stream).thenAnswer(
      (_) => Stream<TopRatedTvSeriesState>.fromIterable([
        TopRatedTvSeriesLoading(),
      ]),
    );
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
    'should display error message when popular movie state is Error',
    (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(TopRatedTvSeriesHasError('Server Failure'));
      whenListen(
        mockBloc,
        Stream.fromIterable([TopRatedTvSeriesHasError('Server Failure')]),
      );

      final textFinder = find.byKey(Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));
      expect(textFinder, findsOneWidget);
    },
  );

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(TopRatedTvSeriesHasData(<TvSeries>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });
}

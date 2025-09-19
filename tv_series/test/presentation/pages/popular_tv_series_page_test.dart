import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:tv_series/presentation/pages/popular_tv_series_page.dart';

// * Create manual mock
class MockPopularTvSeriesBloc extends Mock implements PopularTvSeriesBloc {}

void main() {
  late MockPopularTvSeriesBloc mockBloc;

  setUpAll(() {
    // * Register fallback for mocktail.
    registerFallbackValue(PopularTvSeriesInitial());
  });

  setUp(() {
    mockBloc = MockPopularTvSeriesBloc();

    // * Default stub for popular TvSeries bloc
    when(() => mockBloc.state).thenReturn(PopularTvSeriesLoading());
    when(() => mockBloc.stream).thenAnswer(
      (_) =>
          Stream<PopularTvSeriesState>.fromIterable([PopularTvSeriesLoading()]),
    );
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
    'should display error message when popular movie state is Error',
    (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(PopularTvSeriesHasError('Server Failure'));
      whenListen(
        mockBloc,
        Stream.fromIterable([PopularTvSeriesHasError('Server Failure')]),
      );

      final textFinder = find.byKey(Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));
      expect(textFinder, findsOneWidget);
    },
  );

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(PopularTvSeriesHasData(<TvSeries>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });
}

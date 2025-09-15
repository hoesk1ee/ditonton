import 'package:core/domain/entities/tv_series.dart';
import 'package:core/presentation/pages/tv_series_detail_page.dart';
import 'package:core/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'tv_series_card_list_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NavigatorObserver>()])
void main() {
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
      navigatorObservers: [mockObserver],
      routes: {
        TvSeriesDetailPage.ROUTE_NAME: (context) => Scaffold(
              body: Text('Detail Page'),
            ),
      },
    );
  }

  testWidgets('should display tv series card with name, overview and image',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(TvSeriesCardList(tTvSeries)));

    expect(find.text('name'), findsOneWidget);
    expect(find.text('overview'), findsOneWidget);

    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('should navigate to detail page when tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(TvSeriesCardList(tTvSeries)));

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Detail Page'), findsOneWidget);
  });

  testWidgets('should display "-" when name or overview is null',
      (WidgetTester tester) async {
    final tTvSeriesWithNull = TvSeries(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: [1, 2, 3],
      id: 1,
      originalName: null,
      overview: null,
      popularity: 1,
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      name: null,
      voteAverage: 1,
      voteCount: 1,
    );

    await tester
        .pumpWidget(_makeTestableWidget(TvSeriesCardList(tTvSeriesWithNull)));

    expect(find.text('-'), findsNWidgets(2));
  });

  testWidgets('should display error icon if image fails to load',
      (WidgetTester tester) async {
    final testWidget = MaterialApp(
      home: Scaffold(
        body: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Icon(Icons.error),
          ],
        ),
      ),
    );

    await tester.pumpWidget(testWidget);

    expect(find.byIcon(Icons.error), findsOneWidget);
  });
}

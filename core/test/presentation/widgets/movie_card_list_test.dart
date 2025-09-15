import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/pages/movie_detail_page.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'movie_card_list_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NavigatorObserver>()])
void main() {
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  final tMovies = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
    video: false,
  );

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
      navigatorObservers: [mockObserver],
      routes: {
        MovieDetailPage.ROUTE_NAME: (context) => Scaffold(
              body: Text('Detail Page'),
            ),
      },
    );
  }

  testWidgets('should display movies card with name, overview and image',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(MovieCard(tMovies)));

    expect(find.text('title'), findsOneWidget);
    expect(find.text('overview'), findsOneWidget);

    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('should navigate to detail page when tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(MovieCard(tMovies)));

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Detail Page'), findsOneWidget);
  });

  testWidgets('should display "-" when name or overview is null',
      (WidgetTester tester) async {
    final tMoviesWithNull = Movie(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: [1, 2, 3],
      id: 1,
      originalTitle: null,
      overview: null,
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      title: null,
      voteAverage: 1,
      voteCount: 1,
      video: null,
    );

    await tester.pumpWidget(_makeTestableWidget(MovieCard(tMoviesWithNull)));

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

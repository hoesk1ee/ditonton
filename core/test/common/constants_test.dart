import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Constants file should be fully covered',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: kColorScheme,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: Scaffold(
          drawer: Drawer(),
          body: Column(
            children: [
              // TextStyles
              Text('Heading5', style: kHeading5),
              Text('Heading6', style: kHeading6),
              Text('Subtitle', style: kSubtitle),
              Text('BodyText', style: kBodyText),

              // Colors
              Container(width: 10, height: 10, color: kRichBlack),
              Container(width: 10, height: 10, color: kOxfordBlue),
              Container(width: 10, height: 10, color: kPrussianBlue),
              Container(width: 10, height: 10, color: kMikadoYellow),
              Container(width: 10, height: 10, color: kDavysGrey),
              Container(width: 10, height: 10, color: kGrey),

              // BASE_IMAGE_URL
              Text(BASE_IMAGE_URL),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Heading5'), findsOneWidget);
    expect(find.text('Heading6'), findsOneWidget);
    expect(find.text('Subtitle'), findsOneWidget);
    expect(find.text('BodyText'), findsOneWidget);

    expect(find.text(BASE_IMAGE_URL), findsOneWidget);
  });
}

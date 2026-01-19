import 'package:flutter_test/flutter_test.dart';

import 'package:zero_click/main.dart';

void main() {
  // TODO: Re-enable when full widget testing is set up
  // This test requires provider setup and auth mocking
  testWidgets('App loads correctly', skip: true, (WidgetTester tester) async {
    await tester.pumpWidget(const ZeroClickApp());
    expect(find.text('Kilometerregistratie'), findsOneWidget);
  });
}

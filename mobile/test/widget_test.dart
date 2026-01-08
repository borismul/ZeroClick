import 'package:flutter_test/flutter_test.dart';

import 'package:mileage_tracker/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MileageTrackerApp());
    expect(find.text('Kilometerregistratie'), findsOneWidget);
  });
}


import 'package:flutter_test/flutter_test.dart';
import 'package:your_app_name/main.dart';

void main() {
  testWidgets('QuickRide app displays home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const QuickRideApp());

    expect(find.text('QuickRide'), findsOneWidget);
    expect(find.text('Welcome to QuickRide!'), findsOneWidget);
    expect(find.text('Available Rides'), findsOneWidget);
  });
}

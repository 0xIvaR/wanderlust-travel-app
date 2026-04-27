import 'package:flutter_test/flutter_test.dart';
import 'package:wanderlust/main.dart';

void main() {
  testWidgets('App renders navigation tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
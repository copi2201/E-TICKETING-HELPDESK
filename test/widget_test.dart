import 'package:flutter_test/flutter_test.dart';
import 'package:helpdesk_mobile/app.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const HelpdeskApp());
    expect(find.text('Helpdesk Mobile'), findsOneWidget);
  });
}
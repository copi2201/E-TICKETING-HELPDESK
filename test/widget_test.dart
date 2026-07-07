import 'package:flutter_test/flutter_test.dart';
import 'package:helpdesk_mobile/app.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const HelpdeskApp());
    await tester.pump();

    expect(find.text('E-Ticketing Helpdesk'), findsOneWidget);
    expect(find.text('Universitas Airlangga'), findsOneWidget);

    // Clear the splash timer
    await tester.pump(const Duration(seconds: 4));
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:kelvara/kelvara_app.dart';

void main() {
  testWidgets('KelvaraApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KelvaraApp());
    expect(find.text('KELVARA LENS METER'), findsOneWidget);
    expect(find.text('FOV Angle'), findsOneWidget);
  });
}

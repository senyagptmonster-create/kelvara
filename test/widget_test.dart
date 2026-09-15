import 'package:flutter_test/flutter_test.dart';
import 'package:kelvara/presentation/kelvara_app.dart';

void main() {
  testWidgets('KelvaraApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KelvaraApp());
    expect(find.byType(KelvaraApp), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:personal_ai/app.dart';

void main() {
  testWidgets('Personal AI app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const PersonalAiApp());

    expect(find.text('Personal AI'), findsWidgets);
  });
}

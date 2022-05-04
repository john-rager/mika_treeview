import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mika_treeview/widgets/toggle_text.dart';

void main() {
  group('ToggleText', () {
    testWidgets('toggles properly', (WidgetTester tester) async {
      await tester.pumpWidget(const TestToggleText());

      // Initially toggled off, so there should be no decorated container.
      expect(find.byType(Container), findsNothing);

      // Tap the widget, toggling it on.
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Now toggled on, so there should be a decorated container.
      expect(find.byType(Container), findsOneWidget);

      // Tap the widget, toggling it off.
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Now toggled off, so there should be no decorated container.
      expect(find.byType(Container), findsNothing);
    });
  });
}

class TestToggleText extends StatefulWidget {
  const TestToggleText({Key? key}) : super(key: key);

  @override
  State<TestToggleText> createState() => _TestToggleTextState();
}

class _TestToggleTextState extends State<TestToggleText> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: ToggleText(
                text: 'Hello World!',
                value: value,
                onChanged: (v) {
                  setState(() {
                    value = v;
                  });
                }),
          ),
        ),
      ),
    );
  }
}

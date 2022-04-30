import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mika_treeview/mika_treeview.dart';
import 'package:mika_treeview/widgets/toggle_text.dart';

void main() {
  Node node = {'id': '1', 'name': 'My Node'};
  testWidgets('NodeWidget can be selectable', (WidgetTester tester) async {
    await tester.pumpWidget(TestNodeWidget(
      nodeWidget: NodeWidget(
        node: node,
        isSelectable: true,
        onChanged: (v) {},
      ),
    ));

    // Node is selectable, so the widget should contain a ToggleText.
    expect(find.byType(ToggleText), findsOneWidget);
  });

  testWidgets('NodeWidget can be not-selectable', (WidgetTester tester) async {
    await tester.pumpWidget(TestNodeWidget(
      nodeWidget: NodeWidget(
        node: node,
        isSelectable: false,
      ),
    ));

    // Node is not selectable, so the widget should not contain a ToggleText.
    expect(find.byType(ToggleText), findsNothing);
  });

  testWidgets('NodeWidget can have a trailing widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(TestNodeWidget(
      nodeWidget: NodeWidget(
        node: node,
        isSelectable: false,
        trailingBuilder: (node) {
          return const Text(
            'Trailing',
            key: Key('trailing_key'),
          );
        },
      ),
    ));

    // A trailingBuilder was provided, so the node should have a
    // trailing widget.
    expect(find.byKey(const Key('trailing_key')), findsOneWidget);
  });

  testWidgets('NodeWidget is bolded when it is among search results',
      (WidgetTester tester) async {
    await tester.pumpWidget(TestNodeWidget(
      nodeWidget: NodeWidget(
        node: node,
        isSelectable: false,
        searchResults: const {'1', '2', '3'},
      ),
    ));

    // Node is among search results, so it should be bolded.
    var text = tester.widget<Text>(find.byType(Text));
    expect(text.style!.fontWeight, FontWeight.w800);
  });

  testWidgets('NodeWidget is normal weight when it is not among search results',
      (WidgetTester tester) async {
    await tester.pumpWidget(TestNodeWidget(
      nodeWidget: NodeWidget(
        node: node,
        isSelectable: false,
        searchResults: const {'2', '3'},
      ),
    ));

    // Node is not among search results, so it should be normal weight.
    var text = tester.widget<Text>(find.byType(Text));
    expect(text.style!.fontWeight, null);
  });
}

class TestNodeWidget extends StatefulWidget {
  const TestNodeWidget({Key? key, required this.nodeWidget}) : super(key: key);
  final NodeWidget nodeWidget;

  @override
  State<TestNodeWidget> createState() => _TestToggleTextState();
}

class _TestToggleTextState extends State<TestNodeWidget> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Flex(
            direction: Axis.horizontal,
            children: [widget.nodeWidget],
          ),
        ),
      ),
    );
  }
}

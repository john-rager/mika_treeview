import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mika_treeview/src/tree_search.dart';

import '../data.dart';

void main() {
  group('TreeSearchForm', () {
    testWidgets('returns id\'s of found nodes', (WidgetTester tester) async {
      Set<String> searchResults = {};
      await tester.pumpWidget(TestTreeSearchForm(
        onResults: (results) {
          searchResults = results;
        },
      ));

      await tester.enterText(find.byType(TextField), 'pay');
      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();
      expect(searchResults, {'5', '3'});
    });

    testWidgets('returns empty set if nothing is found',
        (WidgetTester tester) async {
      Set<String> searchResults = {};
      await tester.pumpWidget(TestTreeSearchForm(
        onResults: (results) {
          searchResults = results;
        },
      ));

      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();
      expect(searchResults, <String>{});
    });

    testWidgets('returns empty set if no search string was provided',
        (WidgetTester tester) async {
      Set<String> searchResults = {};
      await tester.pumpWidget(TestTreeSearchForm(
        onResults: (results) {
          searchResults = results;
        },
      ));

      await tester.enterText(find.byType(TextField), '');
      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();
      expect(searchResults, <String>{});
    });

    testWidgets('returns empty set if the clear icon is tapped',
        (WidgetTester tester) async {
      Set<String> searchResults = {};
      await tester.pumpWidget(TestTreeSearchForm(
        onResults: (results) {
          searchResults = results;
        },
      ));

      // Do a search that should return results.
      await tester.enterText(find.byType(TextField), 'pay');
      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();
      // Now clear it.
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(searchResults, <String>{});
    });
  });
}

class TestTreeSearchForm extends StatefulWidget {
  const TestTreeSearchForm({Key? key, required this.onResults})
      : super(key: key);
  final ValueChanged<Set<String>> onResults;

  @override
  State<TestTreeSearchForm> createState() => _TestToggleTextState();
}

class _TestToggleTextState extends State<TestTreeSearchForm> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: TreeSearchForm(
              tree: tree,
              onResults: (results) {
                widget.onResults(results);
              }),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mika_treeview/mika_treeview.dart';
import 'package:mika_treeview/widgets/toggle_text.dart';

import '../data.dart';

void main() {
  group('TreeView', () {
    testWidgets('displays a tree with nodes', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestTreeView(
          tree: tree,
        ),
      );

      expect(find.byType(NodeWidget), findsWidgets);
    });

    testWidgets('displays an empty tree notification if the tree is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestTreeView(
          tree: [],
          emptyTreeNotice: EmptyTreeNotice(),
        ),
      );

      expect(find.byType(EmptyTreeNotice), findsOneWidget);
    });

    testWidgets('expands all', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestTreeView(
          tree: tree,
          treeController: TreeController(allNodesExpanded: false),
        ),
      );

      await tester.tap(find.byKey(const Key('expand_all')));
      await tester.pump();
      // Should find all eight nodes in the test data.
      expect(find.byType(NodeWidget), findsNWidgets(8));
    });

    testWidgets('collapses all', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestTreeView(
          tree: tree,
          treeController: TreeController(allNodesExpanded: true),
        ),
      );

      await tester.tap(find.byKey(const Key('collapse_all')));
      await tester.pump();
      // Should find the three root nodes in the test data.
      expect(find.byType(NodeWidget), findsNWidgets(3));
    });

    testWidgets('select mode = none doesn\'t allow selection',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestTreeView(
          tree: tree,
          selectMode: SelectMode.none,
        ),
      );

      // None of the nodes should be toggle-able.
      expect(find.byType(ToggleText), findsNothing);
    });

    testWidgets('select mode = single allows selection of only one node',
        (WidgetTester tester) async {
      Set<String> selected = {};
      await tester.pumpWidget(
        TestTreeView(
          tree: tree,
          selectMode: SelectMode.single,
          onChanged: (s) {
            selected = s;
          },
        ),
      );

      // All of the nodes should be toggle-able.
      expect(find.byType(ToggleText), findsWidgets);
      // Tapping one node should yield only one selection.
      await tester.tap(find.widgetWithText(GestureDetector, 'Sales'));
      await tester.pump();
      expect(selected.length, 1);
      // Tapping a different node should still yield only one selection.
      await tester.tap(find.widgetWithText(GestureDetector, 'Accounting'));
      await tester.pump();
      expect(selected.length, 1);
      // Tapping the same node again should yield no selection.
      await tester.tap(find.widgetWithText(GestureDetector, 'Accounting'));
      await tester.pump();
      expect(selected.length, 0);
    });

    testWidgets('select mode = multiple allows selection multiple nodes',
        (WidgetTester tester) async {
      Set<String> selected = {};
      await tester.pumpWidget(
        TestTreeView(
          tree: tree,
          selectMode: SelectMode.multiple,
          onChanged: (s) {
            selected = s;
          },
        ),
      );

      // All of the nodes should be toggle-able.
      expect(find.byType(ToggleText), findsWidgets);
      // Tapping one node should yield only one selection.
      await tester.tap(find.widgetWithText(GestureDetector, 'Sales'));
      await tester.pump();
      expect(selected.length, 1);
      // Tapping a different node should yield more than one selection.
      await tester.tap(find.widgetWithText(GestureDetector, 'Accounting'));
      await tester.pump();
      expect(selected.length, 2);
      // Tapping a selected node again should yield only one selection.
      await tester.tap(find.widgetWithText(GestureDetector, 'Accounting'));
      await tester.pump();
      expect(selected.length, 1);
    });

    testWidgets('can provide selected values', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestTreeView(
          tree: tree,
          treeController: TreeController(allNodesExpanded: true),
          selectMode: SelectMode.multiple,
          values: const {'1', '3'},
          onChanged: (s) {},
        ),
      );

      expect(find.byType(Container), findsNWidgets(2));
    });

    testWidgets('can provide no selected values', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestTreeView(
          tree: tree,
          treeController: TreeController(allNodesExpanded: true),
          selectMode: SelectMode.multiple,
          onChanged: (s) {},
        ),
      );

      expect(find.byType(Container), findsNothing);
    });

    testWidgets('can provide a trailing widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestTreeView(
          tree: tree,
          treeController: TreeController(allNodesExpanded: true),
          trailingBuilder: (node) {
            return Text(
              'Trailing',
              key: Key('Trailing ${node['id']}'),
            );
          },
        ),
      );

      expect(find.byKey(const Key('Trailing 1')), findsNWidgets(1));
    });

    testWidgets('isSearchable = true displays tree search form',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestTreeView(
          tree: tree,
          treeController: TreeController(allNodesExpanded: true),
          isSearchable: true,
        ),
      );

      expect(find.byType(TreeSearchForm), findsOneWidget);
    });

    testWidgets('isSearchable = false does not display tree search form',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestTreeView(
          tree: tree,
          treeController: TreeController(allNodesExpanded: true),
          isSearchable: false,
        ),
      );

      expect(find.byType(TreeSearchForm), findsNothing);
    });

    testWidgets('isSorted = true shows Accounting as first node',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestTreeView(
          tree: tree,
          treeController: TreeController(allNodesExpanded: true),
          isSorted: true,
        ),
      );

      final firstNodeWidget =
          tester.widget<NodeWidget>(find.byType(NodeWidget).first);
      expect(firstNodeWidget.node['name'], 'Accounting');
    });

    testWidgets('isSorted = false shows Sales as first node',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestTreeView(
          tree: tree,
          treeController: TreeController(allNodesExpanded: true),
          isSorted: false,
        ),
      );

      final firstNodeWidget =
          tester.widget<NodeWidget>(find.byType(NodeWidget).first);
      expect(firstNodeWidget.node['name'], 'Sales');
    });
  });
}

class TestTreeView extends StatefulWidget {
  const TestTreeView({
    Key? key,
    required this.tree,
    this.treeController,
    this.selectMode = SelectMode.none,
    this.values,
    this.onChanged,
    this.emptyTreeNotice = const SizedBox(),
    this.trailingBuilder,
    this.isSearchable = false,
    this.isSorted = false,
  }) : super(key: key);
  final Tree tree;
  final TreeController? treeController;
  final SelectMode selectMode;
  final Set<String>? values;
  final ValueChanged<Set<String>>? onChanged;
  final Widget emptyTreeNotice;
  final TrailingBuilder<dynamic>? trailingBuilder;
  final bool isSearchable;
  final bool isSorted;

  @override
  State<TestTreeView> createState() => _TestTreeViewState();
}

class _TestTreeViewState extends State<TestTreeView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ListView(children: [
            OutlinedButton(
              key: const Key('expand_all'),
              onPressed: () => setState(() {
                widget.treeController?.expandAll();
              }),
              child: const Text('Expand All'),
            ),
            OutlinedButton(
              key: const Key('collapse_all'),
              onPressed: () => setState(() {
                widget.treeController?.collapseAll();
              }),
              child: const Text('Collapse All'),
            ),
            TreeView(
              tree: widget.tree,
              treeController: widget.treeController,
              selectMode: widget.selectMode,
              values: widget.values,
              onChanged: widget.onChanged,
              emptyTreeNotice: widget.emptyTreeNotice,
              trailingBuilder: widget.trailingBuilder,
              isSearchable: widget.isSearchable,
              isSorted: widget.isSorted,
            ),
          ]),
        ),
      ),
    );
  }
}

class EmptyTreeNotice extends StatelessWidget {
  const EmptyTreeNotice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        children: [
          Icon(
            Icons.account_tree_outlined,
            size: 150.0,
            color: theme.primaryColorLight,
          ),
          const SizedBox(height: 10.0),
          Text(
            'Nothing to show here...',
            style: TextStyle(fontSize: 18.0, color: theme.primaryColorLight),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mika_treeview/mika_treeview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'MIKA TreeView Demo';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TreeController _controller = TreeController(allNodesExpanded: true);
  SelectMode selectMode = SelectMode.single;
  bool includesTrailing = true;
  bool isSorted = true;
  bool isSearchable = true;

  final Tree tree = Tree(
    nodes: [
      Node(
        id: '1',
        name: 'Sales',
      ),
      Node(
        id: '2',
        name: 'Accounting',
        children: [
          Node(
            id: '5',
            name: 'Payroll',
          ),
          Node(
            id: '3',
            name: 'Accounts Payable',
          ),
          Node(
            id: '4',
            name: 'Accounts Receivable',
          ),
        ],
      ),
      Node(
        id: '6',
        name: 'Manufacturing',
        children: [
          Node(
            id: '7',
            name: 'Product Design',
            children: [
              Node(
                id: '8',
                name: 'Research & Development',
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Select Mode'),
              trailing: DropdownButton<SelectMode>(
                  value: selectMode,
                  items: SelectMode.values.map((e) {
                    return DropdownMenuItem<SelectMode>(
                      value: e,
                      child: Text(e.toString()),
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      selectMode = v!;
                    });
                  }),
            ),
            SwitchListTile(
              title: const Text('Searchable'),
              value: isSearchable,
              onChanged: (v) {
                setState(() {
                  isSearchable = v;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Include Trailing'),
              value: includesTrailing,
              onChanged: (v) {
                setState(() {
                  includesTrailing = v;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Sorted'),
              value: isSorted,
              onChanged: (v) {
                setState(() {
                  isSorted = v;
                });
              },
            ),
            ButtonBar(
              children: <Widget>[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(15.0),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () => setState(() {
                    _controller.expandAll();
                  }),
                  child: const Text('Expand All'),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(15.0),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () => setState(() {
                    _controller.collapseAll();
                  }),
                  child: const Text('Collapse All'),
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TreeView(
                tree: tree,
                treeController: _controller,
                selectMode: selectMode,
                values: const {},
                onChanged: (v) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Selected: $v'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                emptyTreeNotice: const EmptyTreeNotice(),
                trailingBuilder: (includesTrailing) ? _trailingBuilder : null,
                isSearchable: isSearchable,
                isSorted: isSorted,
                indent: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trailingBuilder(Node node) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem(
          child: Text('Add'),
          value: Action.add,
        ),
        const PopupMenuItem(
          child: Text('Edit'),
          value: Action.edit,
        ),
        PopupMenuItem(
          child: const Text('Delete'),
          value: Action.delete,
          enabled: (node.children == null),
          textStyle: const TextStyle().copyWith(color: Colors.red),
        )
      ],
      tooltip: 'Actions',
      onSelected: (v) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Action: $v, Item: {${node.id}}'),
          duration: const Duration(seconds: 3),
        ));
      },
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
          const SizedBox(height: 20.0),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              primary: theme.colorScheme.onPrimary,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Action ${Action.add}, Item: {}'),
                duration: const Duration(seconds: 3),
              ));
            },
            child: const Text('Add An Item'),
          )
        ],
      ),
    );
  }
}

enum Action {
  add,
  edit,
  delete,
}

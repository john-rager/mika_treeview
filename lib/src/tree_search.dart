import 'package:flutter/material.dart';

class TreeSearchForm extends StatefulWidget {
  const TreeSearchForm({
    Key? key,
    required this.nodes,
    required this.onResults,
  }) : super(key: key);

  final List<Map<String, dynamic>> nodes;
  final ValueChanged<Set<String>> onResults;

  @override
  State<TreeSearchForm> createState() => _TreeSearchFormState();
}

class _TreeSearchFormState extends State<TreeSearchForm> {
  final searchTextController = TextEditingController();

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: TextField(
                controller: searchTextController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchTextController.clear();
                      widget.onResults(
                        _searchTree(
                          nodes: widget.nodes,
                          text: searchTextController.text,
                        ),
                      );
                    },
                  ),
                ),
                autofocus: true,
              ),
            ),
            const SizedBox(width: 10.0),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(15.0),
                backgroundColor: theme.primaryColor,
                primary: theme.colorScheme.onPrimary,
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                widget.onResults(
                  _searchTree(
                    nodes: widget.nodes,
                    text: searchTextController.text,
                  ),
                );
              },
              child: const Text('Search'),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}

Set<String> _searchTree(
    {required List<Map<String, dynamic>> nodes, required String text}) {
  Set<String> results = {};

  Set<String> traverse({
    required List<Map<String, dynamic>> nodes,
    required String text,
  }) {
    for (Map<String, dynamic> node in nodes) {
      if (node['name'].contains(RegExp(text, caseSensitive: false))) {
        results.add(node['id']);
      }
      if (node['children'] != null) {
        traverse(nodes: node['children'], text: text);
      }
    }
    return results;
  }

  return (text != '') ? traverse(nodes: nodes, text: text) : {};
}

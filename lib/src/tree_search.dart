import 'package:flutter/material.dart';
import 'package:mika_treeview/mika_treeview.dart';

/// A form widget that provides for a recursive case-insensitive search
/// through the tree for any occurrence of the provided text string.
///
/// Once the search is complete, [onResults] is called with a set of the
/// node id's matching the search string.
class TreeSearchForm extends StatefulWidget {
  const TreeSearchForm({
    Key? key,
    required this.tree,
    required this.onResults,
  }) : super(key: key);

  /// The tree to search.
  final Tree tree;

  /// The function to call when the search is complete.
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
                          tree: widget.tree,
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
                    tree: widget.tree,
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

Set<String> _searchTree({required Tree tree, required String text}) {
  Set<String> results = {};

  Set<String> traverse({
    required Tree tree,
    required String text,
  }) {
    for (Node node in tree) {
      if (node['name'].contains(RegExp(text, caseSensitive: false))) {
        results.add(node['id']);
      }
      if (node['children'] != null) {
        traverse(tree: node['children'], text: text);
      }
    }
    return results;
  }

  return (text != '') ? traverse(tree: tree, text: text) : {};
}

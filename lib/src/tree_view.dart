import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart' as fst;
import 'package:mika_treeview/mika_treeview.dart';

/// A tree view widget that extends
/// https://pub.dev/packages/flutter_simple_treeview to provide several
/// useful features.
///
/// * Can accept an alternative widget to render if the tree is empty.
/// * Single or multiple nodes can be toggled as selected.
/// * The tree can be sorted alphabetically.
/// * The tree can be searched.
/// * A trailing widget can be attached to the nodes to provide for use
///   cases such as providing a pop-up menu or a button to take action on a
///   particular node.
class TreeView extends StatefulWidget {
  const TreeView({
    Key? key,
    required this.tree,
    this.selectMode = SelectMode.none,
    this.values,
    this.onChanged,
    this.emptyTreeNotice = const SizedBox(),
    this.nodeActionBuilder,
    this.isSearchable = false,
    this.isSorted = false,
    this.allNodesExpanded = false,
    this.indent = 40.0,
  }) : super(key: key);

  /// The tree to build the tree view from.
  ///
  /// [tree] must be provided as a [List]<[Map]<[String], [dynamic]>>.  See
  /// the package documentation on [pub.dev](https://pub.dev/) for more
  /// information on how to construct [tree].
  final Tree tree;

  /// Specifies the selection behavior for the tree.  See [SelectMode].
  final SelectMode selectMode;

  /// If [selectMode] is [SelectMode.single] or [SelectMode.multiple], this
  /// set of node id's can be used to specify the initially selected node(s).
  final Set<String>? values;

  /// If [isSelectable] is true, this function will be called to indicate
  /// that the node has been tapped.
  final ValueChanged<Set<String>>? onChanged;

  /// Specifies the widget to render if the tree is currently empty.
  final Widget emptyTreeNotice;

  /// Optional function to build a trailing widget such as a pop-up menu or
  /// button, specific for the node.
  final NodeActionBuilder<dynamic>? nodeActionBuilder;

  /// Specifies whether the tree is searchable.  If true, then a
  /// [TreeSearchForm] is rendered above the tree.
  final bool isSearchable;

  /// Specifies whether the tree should be sorted alphabetically.
  final bool isSorted;

  /// See https://pub.dev/packages/flutter_simple_treeview.
  final bool allNodesExpanded;

  /// See https://pub.dev/packages/flutter_simple_treeview.
  final double indent;

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  late fst.TreeController treeController;
  Set<String> values = {};
  Set<String> searchResults = {};
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.onChanged == null && widget.selectMode != SelectMode.none) {
      throw ArgumentError('onChanged is required when selectMode '
          'is other than ${SelectMode.none}');
    }
    treeController =
        fst.TreeController(allNodesExpanded: widget.allNodesExpanded);
    if (widget.values != null) {
      values = {...widget.values!};
    }
  }

  @override
  Widget build(BuildContext context) {
    var tree = _copyTree(widget.tree)!;
    return (widget.tree.isEmpty)
        ? widget.emptyTreeNotice
        : Column(
            children: [
              if (widget.isSearchable)
                TreeSearchForm(
                  tree: tree,
                  onResults: (results) {
                    setState(() {
                      treeController.expandAll();
                      searchResults = results;
                    });
                  },
                ),
              fst.TreeView(
                treeController: treeController,
                indent: widget.indent,
                nodes: _buildTree(
                    tree: tree,
                    isSorted: widget.isSorted,
                    searchResults: searchResults),
              ),
            ],
          );
  }

  Tree? _copyTree(Tree? tree) {
    if (tree == null) {
      return null;
    }
    return tree.map((e) {
      var node = {
        'id': e['id'],
        'name': e['name'],
        if (e['children'] != null) 'children': _copyTree(e['children']),
      };
      return node;
    }).toList();
  }

  List<fst.TreeNode> _buildTree({
    required Tree tree,
    bool isSorted = false,
    required Set<String> searchResults,
  }) {
    if (isSorted) {
      tree.sort((a, b) => (a['name']).compareTo(b['name']));
    }
    return [
      for (final node in tree)
        fst.TreeNode(
          content: NodeWidget(
            node: node,
            isSelectable: widget.selectMode != SelectMode.none,
            isSelected: values.contains(node['id']),
            nodeActionBuilder: widget.nodeActionBuilder,
            searchResults: searchResults,
            onChanged: (isSelected) {
              setState(() {
                if (isSelected) {
                  if (widget.selectMode == SelectMode.single) {
                    values.clear();
                  }
                  values.add(node['id']);
                } else {
                  values.remove(node['id']);
                }
              });
              if (widget.onChanged != null) {
                widget.onChanged!(values);
              }
            },
          ),
          children: (node['children'] != null)
              ? _buildTree(
                  tree: node['children'],
                  isSorted: isSorted,
                  searchResults: searchResults)
              : null,
        )
    ];
  }
}

/// Supported node selection behaviors.
enum SelectMode {
  /// Indicates that the tree doesn't allow node selection.
  none,

  /// Indicates that the tree allows single selection.
  single,

  /// Indicates that the tree allows multiple selection.
  multiple,
}

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
    this.treeController,
    this.selectMode = SelectMode.none,
    this.values,
    this.onChanged,
    this.emptyTreeNotice = const SizedBox(),
    this.trailingBuilder,
    this.isSearchable = false,
    this.isSorted = false,
    this.indent = 40.0,
  }) : super(key: key);

  /// The tree to build the tree view from.
  ///
  /// [tree] must be provided as a [List]<[Map]<[String], [dynamic]>>.  See
  /// the package documentation on [pub.dev](https://pub.dev/) for more
  /// information on how to construct [tree].
  final Tree tree;

  /// See https://pub.dev/packages/flutter_simple_treeview.
  final TreeController? treeController;

  /// Specifies the selection behavior for the tree.  See [SelectMode].
  final SelectMode selectMode;

  /// If [selectMode] is [SelectMode.single] or [SelectMode.multiple], this
  /// set of node id's can be used to specify the initially selected node(s).
  final Set<String>? values;

  /// Makes all nodes selectable, and this function will be called to indicate
  /// that the node has been tapped.
  final ValueChanged<Set<String>>? onChanged;

  /// Specifies the widget to render if the tree is currently empty.
  final Widget emptyTreeNotice;

  /// Optional function to build a trailing widget such as a pop-up menu or
  /// button, specific for the node.
  final TrailingBuilder<Node>? trailingBuilder;

  /// Specifies whether the tree is searchable.  If true, then a
  /// [TreeSearchForm] is rendered above the tree.
  final bool isSearchable;

  /// Specifies whether the tree should be sorted alphabetically.
  final bool isSorted;

  /// See https://pub.dev/packages/flutter_simple_treeview.
  final double indent;

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  TreeController? treeController;
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
    if (widget.values != null &&
        widget.values!.isNotEmpty &&
        widget.selectMode == SelectMode.none) {
      throw ArgumentError(
          'values cannot be provided if selectMode is ${SelectMode.none}');
    }
    if (widget.values != null &&
        widget.values!.length > 1 &&
        widget.selectMode == SelectMode.single) {
      throw ArgumentError('only one value can be provided if selectMode is '
          '${SelectMode.single}');
    }
    treeController = widget.treeController ?? TreeController();
    if (widget.values != null) {
      values = {...widget.values!};
    }
  }

  @override
  Widget build(BuildContext context) {
    Tree tree = widget.tree.copy();

    void _onResults(results) {
      setState(() {
        treeController!.expandAll();
        searchResults = results;
      });
    }

    if ((widget.tree.nodes.isEmpty)) {
      return widget.emptyTreeNotice;
    } else {
      return Column(
        children: [
          Visibility(
            visible: widget.isSearchable,
            child: TreeSearchForm(
              tree: tree,
              onResults: _onResults,
            ),
          ),
          fst.TreeView(
            treeController: treeController,
            indent: widget.indent,
            nodes: _buildTreeNodes(
                nodes: tree.nodes,
                isSorted: widget.isSorted,
                searchResults: searchResults),
          ),
        ],
      );
    }
  }

  List<fst.TreeNode> _buildTreeNodes({
    required List<Node> nodes,
    bool isSorted = false,
    required Set<String> searchResults,
  }) {
    if (isSorted) {
      nodes.sort((a, b) => (a.name).compareTo(b.name));
    }
    return [
      for (final node in nodes)
        fst.TreeNode(
          content: NodeWidget(
            node: node,
            isSelected: values.contains(node.id),
            trailingBuilder: widget.trailingBuilder,
            searchResults: searchResults,
            onChanged: (widget.selectMode == SelectMode.none)
                ? null
                : (isSelected) {
                    setState(() {
                      if (isSelected) {
                        if (widget.selectMode == SelectMode.single) {
                          values.clear();
                        }
                        values.add(node.id);
                      } else {
                        values.remove(node.id);
                      }
                    });
                    if (widget.onChanged != null) {
                      widget.onChanged!(values);
                    }
                  },
          ),
          children: (node.children != null)
              ? _buildTreeNodes(
                  nodes: node.children!,
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

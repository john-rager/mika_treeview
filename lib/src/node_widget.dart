import 'package:flutter/material.dart';
import 'package:mika_treeview/mika_treeview.dart';

import '../widgets/toggle_text.dart';

typedef TrailingBuilder<N> = Widget Function(N node);

/// A widget that represents the visual appearance of a node in the tree.
class NodeWidget extends StatefulWidget {
  const NodeWidget({
    Key? key,
    required this.node,
    this.isSelectable = false,
    this.isSelected,
    this.trailingBuilder,
    this.searchResults = const {},
    this.onChanged,
  }) : super(key: key);

  /// The node to generate a node widget from.
  final Node node;

  /// Indicates whether the node is selectable.  See [ToggleText].
  final bool isSelectable;

  /// Indicates whether the node has been selected.
  final bool? isSelected;

  /// Optional function to build a trailing widget such as a pop-up menu or
  /// button, specific for the node.
  final TrailingBuilder<dynamic>? trailingBuilder;

  /// If [TreeView.isSearchable] is true, this will contain the set of node
  /// id's from a search.  This is used to determine whether the node text
  /// should be highlighted as found.
  final Set<String> searchResults;

  /// If [isSelectable] is true, this function will be called to indicate
  /// that the node has been tapped.
  final ValueChanged<bool>? onChanged;

  @override
  State<NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          (widget.isSelectable)
              ? ToggleText(
                  text: widget.node['name'],
                  value: widget.isSelected ?? false,
                  style: (widget.searchResults.contains(widget.node['id']))
                      ? const TextStyle(fontWeight: FontWeight.w800)
                      : const TextStyle(),
                  onChanged: (v) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(v);
                    }
                  },
                )
              : Text(
                  widget.node['name'],
                  style: (widget.searchResults.contains(widget.node['id']))
                      ? const TextStyle(fontWeight: FontWeight.w800)
                      : const TextStyle(),
                ),
          const Spacer(),
          if (widget.trailingBuilder != null)
            widget.trailingBuilder!(widget.node),
        ],
      ),
    );
  }
}

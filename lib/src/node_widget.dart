import 'package:flutter/material.dart';
import 'package:mika_treeview/mika_treeview.dart';

import '../widgets/toggle_text.dart';

typedef NodeActionBuilder<N> = Widget Function(N node);

class NodeWidget extends StatefulWidget {
  const NodeWidget({
    Key? key,
    required this.node,
    this.isSelectable = false,
    this.isSelected,
    this.nodeActionBuilder,
    this.searchResults = const {},
    this.onChanged,
  }) : super(key: key);

  /// The node to generate a node widget from.
  final Node node;

  /// Indicates whether the node should be selectable.
  final bool isSelectable;

  /// Indicates whether the node has been selected.
  final bool? isSelected;
  final NodeActionBuilder<dynamic>? nodeActionBuilder;
  final Set<String> searchResults;
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
          if (widget.nodeActionBuilder != null)
            widget.nodeActionBuilder!(widget.node),
        ],
      ),
    );
  }
}

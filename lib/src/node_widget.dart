import 'package:flutter/material.dart';
import 'package:mika_treeview/mika_treeview.dart';

import '../widgets/toggle_text.dart';

typedef TrailingBuilder<N> = Widget Function(N node);

/// A widget that represents the visual appearance of a node in the tree.
class NodeWidget extends StatelessWidget {
  const NodeWidget(
      {Key? key,
      required this.node,
      this.isSelected,
      this.trailingBuilder,
      this.searchResults = const {},
      this.onChanged})
      : super(key: key);

  /// The node to generate a node widget from.
  final Node node;

  /// Indicates whether the node has been selected.
  final bool? isSelected;

  /// Optional function to build a trailing widget such as a pop-up menu or
  /// button, specific for the node.
  final TrailingBuilder<Node>? trailingBuilder;

  /// If [TreeView.isSearchable] is true, this will contain the set of node
  /// id's from a search.  This is used to determine whether the node text
  /// should be highlighted as found.
  final Set<String> searchResults;

  /// Makes the node selectable, and this function will be called to indicate
  /// that the node has been tapped.
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          if (onChanged != null)
            ToggleText(
              text: node.name,
              value: isSelected ?? false,
              style: (searchResults.contains(node.id))
                  ? const TextStyle(fontWeight: FontWeight.w800)
                  : const TextStyle(),
              onChanged: onChanged!,
            )
          else
            Text(
              node.name,
              style: (searchResults.contains(node.id))
                  ? const TextStyle(fontWeight: FontWeight.w800)
                  : const TextStyle(),
            ),
          const Spacer(),
          if (trailingBuilder != null) trailingBuilder!(node),
        ],
      ),
    );
  }
}

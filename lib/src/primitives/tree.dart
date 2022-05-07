import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mika_treeview/src/primitives/node.dart';

/// Data structure of an n-ary tree.
class Tree {
  /// Root node(s) of the tree.
  final List<Node> nodes;

  Tree({
    required this.nodes,
  });

  Tree copyWith({
    List<Node>? nodes,
  }) {
    return Tree(
      nodes: nodes ?? this.nodes,
    );
  }

  /// Creates a deep copy of a tree.
  Tree copy() {
    return Tree.fromMap(toMap());
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nodes': nodes.map((x) => x.toMap()).toList(),
    };
  }

  factory Tree.fromMap(Map<String, dynamic> map) {
    return Tree(
      nodes: List<Node>.from(
        (map['nodes'] as List<dynamic>).map<Node>(
          (x) => Node.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Tree.fromJson(String source) =>
      Tree.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Creates a tree structure from a flat structure.
  ///
  /// ```dart
  /// final Tree tree = Tree.fromFlat(flatData);
  /// ```
  ///
  /// The flat structure must be a `List<Map<String, dynamic>>`, each entry
  /// containing an `id`, `name`, and `parent_id` keys. `id` must be unique.
  /// `parent_id` must be either an `id` of a node or `null` to indicate a
  /// root node.  The order of the nodes is not important as the method will
  /// cycle as many times as necessary until all nodes are resolved to a parent
  /// or root node.
  ///
  /// Here's an example input:
  ///
  /// ```dart
  ///     List<Map<String, dynamic>> flatData = [
  ///      {'id': 1, 'name': 'Accounting', 'parent_id': null},
  ///      {'id': 4, 'name': 'Payroll', 'parent_id': 1},
  ///      {'id': 5, 'name': 'Sales', 'parent_id': null},
  ///      {'id': 6, 'name': 'Manufacturing', 'parent_id': null},
  ///      {'id': 7, 'name': 'Product Design', 'parent_id': 6},
  ///      {'id': 8, 'name': 'Lead Generation', 'parent_id': 5},
  ///      {'id': 9, 'name': 'Research & Development', 'parent_id': 7},
  ///      {'id': 3, 'name': 'Accounts Payable', 'parent_id': 1},
  ///      {'id': 11, 'name': 'Parts Inventory', 'parent_id': 10},
  ///      {'id': 2, 'name': 'Accounts Receivable', 'parent_id': 1},
  ///      {'id': 10, 'name': 'Logistics', 'parent_id': 6}
  ///    ];
  /// ```
  ///
  /// Throws a [FormatException] if any children nodes point to a non-
  /// existent parent node.
  factory Tree.fromFlat(List<Map<String, dynamic>> data) {
    Map<String, dynamic> map = {'nodes': []};

    Map<String, dynamic>? _searchNodes({
      required List<dynamic> nodes,
      required String id,
    }) {
      Map<String, dynamic>? result;

      for (var node in nodes) {
        if (node['id'] == id) {
          return node;
        } else if (node['children'] != null) {
          result = _searchNodes(nodes: node['children']!, id: id);
          if (result != null) return result;
        }
      }

      return null;
    }

    // Check for orphan nodes (nodes with parent_id's that don't exist).
    Set ids = {};
    Set parentIds = {};
    for (var node in data) {
      ids.add(node['id']);
      if (node['parent_id'] != null) {
        parentIds.add(node['parent_id']);
      }
    }
    if (!ids.containsAll(parentIds)) {
      throw const FormatException('Orphan node(s) detected');
    }

    // Cycle through nodes until all resolve to either a parent or the root,
    // so the order that the nodes are presented doesn't matter.
    var remaining = [...data];
    while (remaining.isNotEmpty) {
      var added = [];
      for (var node in remaining) {
        if (node['parent_id'] == null) {
          map['nodes'].add({'id': node['id'].toString(), 'name': node['name']});
          added.add(node);
        } else {
          var parentNode = _searchNodes(
              nodes: map['nodes'], id: node['parent_id'].toString());
          if (parentNode != null) {
            if (parentNode['children'] != null) {
              parentNode['children']!
                  .add({'id': node['id'].toString(), 'name': node['name']});
            } else {
              parentNode['children'] = [
                {'id': node['id'].toString(), 'name': node['name']}
              ];
            }
            added.add(node);
          }
        }
      }
      remaining.removeWhere((e) => added.contains(e));
    }

    return Tree.fromMap(map);
  }

  @override
  String toString() => 'Tree(nodes: $nodes)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tree && listEquals(other.nodes, nodes);
  }

  @override
  int get hashCode => nodes.hashCode;
}

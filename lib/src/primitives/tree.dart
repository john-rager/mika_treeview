import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mika_treeview/src/primitives/node.dart';

class Tree {
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

  factory Tree.fromFlat(List<Map<String, dynamic>> data) {
    Map<String, dynamic> map = {'nodes': []};

    Map<String, dynamic>? searchNodes({
      required List<dynamic> nodes,
      required String id,
    }) {
      Map<String, dynamic>? result;

      for (var node in nodes) {
        if (node['id'] == id) {
          return node;
        } else if (node['children'] != null) {
          result = searchNodes(nodes: node['children']!, id: id);
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
          var parentNode = searchNodes(
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

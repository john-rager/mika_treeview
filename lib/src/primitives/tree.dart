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

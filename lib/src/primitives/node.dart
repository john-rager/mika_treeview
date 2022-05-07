import 'dart:convert';

import 'package:flutter/foundation.dart';

/// Data structure of a node in the tree.
class Node {
  /// A unique identifier of the node.
  final String id;

  /// The name of the node as it will appear in the tree.
  final String name;

  /// Children, if any.
  final List<Node>? children;

  Node({
    required this.id,
    required this.name,
    this.children,
  });

  Node copyWith({
    String? id,
    String? name,
    List<Node>? children,
  }) {
    return Node(
      id: id ?? this.id,
      name: name ?? this.name,
      children: children ?? this.children,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'children': children?.map((x) => x.toMap()).toList(),
    };
  }

  factory Node.fromMap(Map<String, dynamic> map) {
    return Node(
      id: map['id'] as String,
      name: map['name'] as String,
      children: map['children'] != null
          ? List<Node>.from(
              (map['children'] as List<dynamic>).map<Node?>(
                (x) => Node.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Node.fromJson(String source) =>
      Node.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Node(id: $id, name: $name, children: $children)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Node &&
        other.id == id &&
        other.name == name &&
        listEquals(other.children, children);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ children.hashCode;
}

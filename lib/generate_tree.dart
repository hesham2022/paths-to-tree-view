import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

class Tree {
  final String id;
  final List<Tree> subtree;
  bool get isLeaf => subtree.isEmpty;
  TreeNode toTreeNode() {
    return TreeNode(
        content: Text(id),
        children: subtree.map((e) => e.toTreeNode()).toList());
  }

  Tree({
    required this.id,
    required this.subtree,
  });

  Tree copyWith({
    String? id,
    List<Tree>? subtree,
  }) {
    return Tree(
      id: id ?? this.id,
      subtree: subtree ?? this.subtree,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subtree': subtree.map((e) => e.toMap()).toList(),
    };
  }

  factory Tree.fromMap(Map<String, dynamic> map) {
    return Tree(
      id: map['id'] ?? '',
      subtree: List<Tree>.from(map['subtree']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Tree.fromJson(String source) => Tree.fromMap(json.decode(source));

  @override
  String toString() => 'Tree(id: $id, subtree: $subtree)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    // final listEquals = const DeepCollectionEquality().equals;

    return other is Tree && other.id == id;
    // listEquals(other.subtree, subtree);
  }

  @override
  int get hashCode => id.hashCode ^ subtree.hashCode;
}

final paths = [
  'cars/sport/ferrari/Competizione',
  'cars/sport/ferrari/Monza',
  'cars/sport/chevorlet/corvette',
  'cars/4wheel/jeep/wrangler',
  'cars/4wheel/hummer/h2',
  'bikes/race/honda/aar',
  'cars/4wheel/hummer/h3',
  'bikes/race/honda/cbr',
];
List<Tree> generateTree() {
  List<Tree> result = [];

  final routes = paths.map((e) => e.split('/')).toList();
  for (var element in routes) {
    element.fold<List<Tree>>(result, (value, element) {
      if (!value.map((e) => e.id).toList().contains(element)) {
        final newTree = Tree(id: element, subtree: []);
        value.add(newTree);
        print('_'*100);
        print('value: $value');
        print('result: $result');
        return newTree.subtree;
      } else {
        print('*'*100);
        print(value.toString());
        return value.firstWhere((v) => v.id == element).subtree;
      }
    });
  }
  return result;
}

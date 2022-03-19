import 'package:flutter/material.dart';
import 'package:flutter_circle_packing/data_node.dart';
import 'package:flutter_circle_packing/src/datum.dart';
import 'package:flutter_circle_packing/src/hierarchy_node.dart';
import 'package:flutter_test/flutter_test.dart';

HierarchyNode<DataNode> root = HierarchyNode(
  data: DataNode(name: 'Root'),
  children: [
    HierarchyNode(data: DataNode(name: 'child1'), children: []),
    HierarchyNode(data: DataNode(name: 'child2'), children: [
      HierarchyNode(data: DataNode(name: 'grandchild1'), children: [
        HierarchyNode(
            data: DataNode(name: "grand_grandchild1_1"), children: []),
        HierarchyNode(
            data: DataNode(name: "grand_grandchild1_2"), children: []),
      ]),
      HierarchyNode(data: DataNode(name: 'grandchild2'), children: [
        HierarchyNode(
            data: DataNode(name: "grand_grandchild2_1"), children: []),
        HierarchyNode(
            data: DataNode(name: "grand_grandchild2_2"), children: []),
      ]),
    ])
  ],
);

void main() {
  test('test eachAfter', () {
    List<String> results = [];
    root.eachAfter((p0) {
      debugPrint(p0.data!.name);
      results.add(p0.data!.name);
    });

    expect(results, [
      'child1',
      'grand_grandchild1_1',
      'grand_grandchild1_2',
      'grandchild1',
      'grand_grandchild2_1',
      'grand_grandchild2_2',
      'grandchild2',
      'child2',
      'Root',
    ]);
  });

  test('test eachBefore', () {
    List<String> results = [];
    root.eachBefore((p0) {
      debugPrint(p0.data!.name);
      results.add(p0.data!.name);
    });

    expect(results, [
      'Root',
      'child1',
      'child2',
      'grandchild1',
      'grand_grandchild1_1',
      'grand_grandchild1_2',
      'grandchild2',
      'grand_grandchild2_1',
      'grand_grandchild2_2',
    ]);
  });
}

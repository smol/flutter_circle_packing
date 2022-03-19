import 'dart:developer';

import 'package:flutter_circle_packing/data_node.dart';
import 'package:flutter_circle_packing/src/hierarchy.dart';
import 'package:flutter_circle_packing/src/hierarchy_node.dart';
import 'package:flutter_test/flutter_test.dart';

DataNode root = DataNode(
  name: 'Root',
  children: [
    DataNode(name: "child1"),
    DataNode(name: "child2", children: [
      DataNode(name: "grandchild1", children: [
        DataNode(name: "grand_grandchild1_1"),
        DataNode(name: "grand_grandchild1_2"),
      ]),
      DataNode(name: "grandchild2", children: [
        DataNode(name: "grand_grandchild2_1"),
        DataNode(name: "grand_grandchild2_2"),
      ]),
    ])
  ],
);

void main() {
  test("should test hierarchy", () {
    var hierarchy = Hierarchy(root);

    inspect(hierarchy.root);
    expect(hierarchy.root.data!.name, 'Root');
    expect(hierarchy.root.children.length, 2);
  });
}

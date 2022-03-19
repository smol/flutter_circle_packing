import 'dart:developer';

import 'package:flutter_circle_packing/data_node.dart';
import 'package:flutter_circle_packing/src/hierarchy.dart';
import 'package:flutter_circle_packing/src/pack.dart';
import 'package:flutter_test/flutter_test.dart';

DataNode root = DataNode(
  name: 'Root',
  value: 10,
  children: [
    DataNode(name: "child1", value: 12),
    DataNode(name: "child2", value: 13, children: [
      DataNode(name: "grandchild1", value: 131, children: [
        DataNode(name: "grand_grandchild1_1", value: 135),
        DataNode(name: "grand_grandchild1_2", value: 156),
      ]),
      DataNode(name: "grandchild2", value: 20, children: [
        DataNode(name: "grand_grandchild2_1", value: 231),
        DataNode(name: "grand_grandchild2_2", value: 250),
        DataNode(name: "grand_grandchild2_2", value: 256),
      ]),
    ])
  ],
);

void main() {
  test('test pack', () {
    Hierarchy hierarchy = Hierarchy(root);

    Pack pack = Pack(hierarchy.root);

    inspect(pack.root);
    expect(1, 1);
  });
}

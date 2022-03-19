import 'package:flutter_circle_packing/src/datum.dart';
import 'package:flutter_circle_packing/src/hierarchy_node.dart';

class HierarchyCircularNode extends HierarchyNode {
  double x;
  double y;
  double r;

  @override
  HierarchyCircularNode? get parent {
    return super.parent as HierarchyCircularNode?;
  }

  List<HierarchyCircularNode> get children {
    return super.children as List<HierarchyCircularNode>;
  }

  HierarchyCircularNode({
    data,
    this.r = 0,
    this.y = 0,
    this.x = 0,
    required List<HierarchyCircularNode> children,
  }) : super(data: data, children: children);

  @override
  HierarchyCircularNode eachBefore(
      void Function(HierarchyCircularNode) callback) {
    callback(this);

    for (var c in children) {
      c.eachBefore(callback);
    }

    return this;
  }

  @override
  HierarchyCircularNode eachAfter(Function(HierarchyCircularNode) callback) {
    for (var c in children) {
      c.eachAfter(callback);
    }

    callback(this);

    return this;
  }

  factory HierarchyCircularNode.fromNode(
      HierarchyNode node, HierarchyCircularNode? parent) {
    var newNode = HierarchyCircularNode(
      data: node.data,
      children: [],
    )
      ..parent = parent
      ..depth = node.depth
      ..height = node.depth
      ..id = node.id
      ..value = node.value;

    newNode.children = node.children
        .map((e) => HierarchyCircularNode.fromNode(e, newNode))
        .toList();

    return newNode;
  }
}

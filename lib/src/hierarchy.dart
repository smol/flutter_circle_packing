import 'package:flutter_circle_packing/src/datum.dart';
import 'package:flutter_circle_packing/src/hierarchy_node.dart';

class Hierarchy {
  late HierarchyNode root;

  int Function(Map<String, dynamic>)? value;

  Hierarchy({
    required Map<String, dynamic> data,
    this.value,
  }) {
    root = HierarchyNode(
      data: data,
      children: [],
      value: _computeValue(data),
    );

    List<Map<String, dynamic>> Function(Map<String, dynamic>) childrenFunc =
        _objectChildren;

    List<HierarchyNode> nodes = [root];
    HierarchyNode node;

    do {
      if (nodes.isEmpty) {
        break;
      }

      node = nodes.removeLast();
      node.children = <HierarchyNode>[];

      var children = childrenFunc(node.data!);
      var n = children.length;
      if (n > 0) {
        for (var i = n - 1; i >= 0; i--) {
          var child = HierarchyNode(
            data: children[i],
            children: [],
            value: _computeValue(children[i]),
          );
          child.parent = node;
          child.depth = node.depth + 1;
          nodes.add(child);

          node.children.add(child);
        }
      }
    } while (node != null);
    root.eachBefore(_computeHeight);
  }

  int _computeValue(Map<String, dynamic> d) {
    return value != null ? value!(d) : 0;
  }

  void _computeHeight(HierarchyNode node) {
    var height = 0;
    HierarchyNode? prime = node;

    do {
      prime?.height = height;
      prime = prime?.parent;
    } while (prime != null && prime.height < ++height);
  }

  List<Map<String, dynamic>> _objectChildren(Map<String, dynamic> d) {
    return d.containsKey("children")
        ? (d["children"] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList()
        : [];
  }
}

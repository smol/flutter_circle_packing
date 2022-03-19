import 'package:flutter_circle_packing/src/datum.dart';

class HierarchyNode {
  Map<String, dynamic>? data;

  int depth = 0;
  int height = 0;

  int value = 0;
  String? id;

  HierarchyNode? parent;
  List<HierarchyNode> children = [];

  HierarchyNode({
    required this.data,
    required this.children,
    this.value = 0,
  });

  void ancestors() {}

  void descendants() {}

  void leaves() {}

  void find(int Function(HierarchyNode) filter) {}

  void path(HierarchyNode node) {}

  void links() {}

  HierarchyNode sort(int Function(HierarchyNode, HierarchyNode) compare) {
    eachBefore((p0) {
      if (p0.children.isNotEmpty) {
        p0.children.sort(compare);
      }
    });
    return this;
  }

  HierarchyNode count() {
    eachAfter((p0) {
      var sum = 0, c = p0.children, i = c.length;
      if (i == 0) {
        sum = 1;
      } else {
        while (--i >= 0) {
          sum += c[i].value;
        }
      }
      p0.value = sum;
    });

    return this;
  }

  void sum(int Function(Map<String, dynamic>) callback) {
    eachAfter((p0) {
      var sum = p0.data != null ? callback(p0.data!) : 0,
          c = p0.children,
          i = c.length;

      while (--i >= 0) {
        sum += c[i].value;
      }

      p0.value = sum;
    });
  }

  HierarchyNode eachBefore(void Function(HierarchyNode) callback) {
    callback(this);

    for (var c in children) {
      c.eachBefore(callback);
    }

    return this;
  }

  HierarchyNode eachAfter(void Function(HierarchyNode) callback) {
    for (var c in children) {
      c.eachAfter(callback);
    }

    callback(this);

    return this;
  }
}

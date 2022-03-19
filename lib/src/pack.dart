import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_circle_packing/src/datum.dart';
import 'package:flutter_circle_packing/hierarchy_circular_node.dart';
import 'package:flutter_circle_packing/src/hierarchy_node.dart';
import 'package:flutter_circle_packing/src/siblings.dart';

double defaultRadius(HierarchyCircularNode n) {
  return sqrt(n.value);
}

class Pack<T extends Datum> {
  HierarchyCircularNode root;

  double? radius;
  double _dx;
  double _dy;

  Pack({
    required HierarchyNode node,
    double Function(HierarchyCircularNode)? radius,
    Function(HierarchyCircularNode)? padding,
    double width = 1,
    double height = 1,
  })  : root = HierarchyCircularNode.fromNode(node, null),
        _dx = width,
        _dy = height {
    root.x = _dx / 2;
    root.y = _dy / 2;

    padding ??= (p0) => 0;

    if (radius != null) {
      root
          .eachBefore(radiusLeaf(radius))
          .eachAfter(packChildren(padding, 0.5))
          .eachBefore(translateChild(1));
    } else {
      root
          .eachBefore(radiusLeaf(defaultRadius))
          .eachAfter(packChildren((e) => 0, 1))
          .eachAfter(packChildren(padding, root.r / min(_dx, _dy)))
          .eachBefore(translateChild(min(_dx, _dy) / (2 * root.r)));
    }
  }
}

Function(HierarchyCircularNode) translateChild(double k) {
  return (node) {
    var parent = node.parent;
    node.r *= k;
    if (parent != null) {
      node.x = parent.x + k * node.x;
      node.y = parent.y + k * node.y;
    }
  };
}

Function(HierarchyCircularNode) packChildren(
    Function(HierarchyCircularNode) padding, double k) {
  return (node) {
    var children = node.children;
    if (children.isNotEmpty) {
      var i = 0, n = children.length, r = padding(node) * k, e;

      if (r != 0) {
        for (i = 0; i < n; ++i) {
          children[i].r += r;
        }
      }

      e = packEnclose(children);
      if (r != 0) {
        for (i = 0; i < n; ++i) {
          children[i].r -= r;
        }
      }

      node.r = e + r;
    }
  };
}

Function(HierarchyCircularNode) radiusLeaf(radius) {
  return (node) {
    if (node.children.isEmpty) {
      node.r = max(0, radius(node));
    }
  };
}

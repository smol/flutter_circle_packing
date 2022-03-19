import 'dart:math';

import 'package:flutter_circle_packing/src/enclose.dart';
import 'package:flutter_circle_packing/hierarchy_circular_node.dart';

class Node {
  HierarchyCircularNode node;
  Node? next;
  Node? previous;

  Node({required this.node});
}

bool _intersects(HierarchyCircularNode a, HierarchyCircularNode b) {
  var dr = a.r + b.r - 1e-6, dx = b.x - a.x, dy = b.y - a.y;
  return dr > 0 && dr * dr > dx * dx + dy * dy;
}

double _score(Node node) {
  var a = node.node, b = node.next!.node;
  var ab = a.r + b.r,
      dx = (a.x * b.r + b.x * a.r) / ab,
      dy = (a.y * b.r + b.y * a.r) / ab;
  return dx * dx + dy * dy;
}

void place(
  HierarchyCircularNode b,
  HierarchyCircularNode a,
  HierarchyCircularNode c,
) {
  var dx = b.x - a.x, x, a2;
  var dy = b.y - a.y, y, b2;
  var d2 = dx * dx + dy * dy;

  if (d2 != 0) {
    a2 = a.r + c.r;
    a2 *= a2;

    b2 = b.r + c.r;
    b2 *= b2;

    if (a2 > b2) {
      x = (d2 + b2 - a2) / (2 * d2);
      y = sqrt(max(0, b2 / d2 - x * x));

      c.x = b.x - x * dx - y * dy;
      c.y = b.y - x * dy + y * dx;
    } else {
      x = (d2 + a2 - b2) / (2 * d2);
      y = sqrt(max(0, a2 / d2 - x * x));

      c.x = a.x + x * dx - y * dy;
      c.y = a.y + x * dy + y * dx;
    }
  } else {
    c.x = a.x + c.r;
    c.y = a.y;
  }
}

double packEnclose(List<HierarchyCircularNode> nodes) {
  int n = nodes.length;
  if (nodes.isEmpty) {
    return 0;
  }

  HierarchyCircularNode a = nodes[0];
  var aa, ca, i;

  a = nodes[0];
  a.x = 0;
  a.y = 0;

  if (!(nodes.length > 1)) return a.r;

  HierarchyCircularNode b = nodes[1];
  a.x = -b.r;
  b.x = a.r;
  b.y = 0;

  if (!(nodes.length > 2)) return a.r + b.r;

  HierarchyCircularNode c = nodes[2];

  place(b, a, c);

  var node_a = Node(node: a), node_b = Node(node: b), node_c = Node(node: c);

  node_a.next = node_c.previous = node_b;
  node_b.next = node_a.previous = node_c;
  node_c.next = node_b.previous = node_a;

  Node j, k;
  double sj, sk;

  pack:
  for (var i = 3; i < n; ++i) {
    c = nodes[i];
    place(node_a.node, node_b.node, c);
    node_c = Node(node: c);

    j = node_b.next!;
    k = node_a.previous!;
    sj = node_b.node.r;
    sk = node_a.node.r;

    do {
      if (sj <= sk) {
        if (_intersects(j.node, node_c.node)) {
          node_b = j;
          node_a = node_b;
          node_b.previous = node_a;
          --i;
          continue pack;
        }

        sj += j.node.r;
        j = j.next!;
      } else {
        if (_intersects(k.node, node_c.node)) {
          node_a = k;
          node_a.next = node_b;
          node_b.previous = node_a;
          --i;
          continue pack;
        }
        sk += k.node.r;
        k = k.previous!;
      }
    } while (j != k.next);

    node_c.previous = node_a;
    node_c.next = node_b;
    node_a.next = node_b.previous = node_b = node_c;

    aa = _score(node_a);

    while ((node_c = node_c.next!) != node_b) {
      ca = _score(node_c);
      if (ca < aa) {
        a = c;
        aa = ca;
      }
    }

    node_b = node_a.next!;
  }

  var ta = [node_b.node];
  node_c = node_b;
  while ((node_c = node_c.next!) != node_b) {
    ta.add(node_c.node);
  }

  c = enclose(ta);

  for (i = 0; i < n; ++i) {
    a = nodes[i];
    a.x -= c.x;
    a.y -= c.y;
  }

  return c.r;
}

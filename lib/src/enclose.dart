import 'dart:math';

import '../hierarchy_circular_node.dart';

HierarchyCircularNode enclose(List<HierarchyCircularNode> circles) {
  circles.shuffle();

  int i = 0, n = circles.length;
  HierarchyCircularNode? p, e;
  List<HierarchyCircularNode> B = [];

  while (i < n) {
    p = circles[i];
    if (e != null && _enclosesWeak(e, p)) {
      ++i;
    } else {
      B = _extendBasis(B, p);
      e = _encloseBasis(B);
      i = 0;
    }
  }

  return e!;
}

bool _enclosesWeak(HierarchyCircularNode a, HierarchyCircularNode b) {
  var dr = a.r - b.r + max(max(a.r, b.r), 1) * 1e-9,
      dx = b.x - a.x,
      dy = b.y - a.y;
  return dr > 0 && dr * dr > dx * dx + dy * dy;
}

bool _enclosesNot(HierarchyCircularNode a, HierarchyCircularNode b) {
  var dr = a.r - b.r, dx = b.x - a.x, dy = b.y - a.y;
  return dr < 0 || dr * dr < dx * dx + dy * dy;
}

bool _enclosesWeakAll(HierarchyCircularNode a, List<HierarchyCircularNode> B) {
  for (var i = 0; i < B.length; i++) {
    if (!_enclosesWeak(a, B[i])) {
      return false;
    }
  }

  return true;
}

HierarchyCircularNode _encloseBasis1(HierarchyCircularNode a) {
  return HierarchyCircularNode(x: a.x, y: a.y, r: a.r, children: []);
}

HierarchyCircularNode _encloseBasis2(
    HierarchyCircularNode a, HierarchyCircularNode b) {
  var x1 = a.x,
      y1 = a.y,
      r1 = a.r,
      x2 = b.x,
      y2 = b.y,
      r2 = b.r,
      x21 = x2 - x1,
      y21 = y2 - y1,
      r21 = r2 - r1,
      l = sqrt(x21 * x21 + y21 * y21);

  return HierarchyCircularNode(
      x: (x1 + x2 + x21 / l * r21) / 2,
      y: (y1 + y2 + y21 / l * r21) / 2,
      r: (l + r1 + r2) / 2,
      children: []);
}

HierarchyCircularNode _encloseBasis3(
    HierarchyCircularNode a, HierarchyCircularNode b, HierarchyCircularNode c) {
  var x1 = a.x,
      y1 = a.y,
      r1 = a.r,
      x2 = b.x,
      y2 = b.y,
      r2 = b.r,
      x3 = c.x,
      y3 = c.y,
      r3 = c.r,
      a2 = x1 - x2,
      a3 = x1 - x3,
      b2 = y1 - y2,
      b3 = y1 - y3,
      c2 = r2 - r1,
      c3 = r3 - r1,
      d1 = x1 * x1 + y1 * y1 - r1 * r1,
      d2 = d1 - x2 * x2 - y2 * y2 + r2 * r2,
      d3 = d1 - x3 * x3 - y3 * y3 + r3 * r3,
      ab = a3 * b2 - a2 * b3,
      xa = (b2 * d3 - b3 * d2) / (ab * 2) - x1,
      xb = (b3 * c2 - b2 * c3) / ab,
      ya = (a3 * d2 - a2 * d3) / (ab * 2) - y1,
      yb = (a2 * c3 - a3 * c2) / ab,
      A = xb * xb + yb * yb - 1,
      B = 2 * (r1 + xa * xb + ya * yb),
      C = xa * xa + ya * ya - r1 * r1,
      r = -(A != 0 ? (B + sqrt(B * B - 4 * A * C)) / (2 * A) : C / B);
  return HierarchyCircularNode(
    x: x1 + xa + xb * r,
    y: y1 + ya + yb * r,
    r: r,
    children: [],
  );
}

HierarchyCircularNode _encloseBasis(List<HierarchyCircularNode> B) {
  switch (B.length) {
    case 1:
      return _encloseBasis1(B[0]);
    case 2:
      return _encloseBasis2(B[0], B[1]);
    case 3:
      return _encloseBasis3(B[0], B[1], B[2]);
  }

  throw 'ERROR';
}

List<HierarchyCircularNode> _extendBasis(
  List<HierarchyCircularNode> B,
  HierarchyCircularNode p,
) {
  var i, j;

  if (_enclosesWeakAll(p, B)) {
    return [p];
  }

  for (i = 0; i < B.length; ++i) {
    if (_enclosesNot(p, B[i])) {
      if (_enclosesWeakAll(_encloseBasis2(B[i], p), B)) {
        return [B[i], p];
      }
    }
  }

  for (i = 0; i < B.length - 1; ++i) {
    for (j = i + 1; j < B.length; ++j) {
      if (_enclosesNot(_encloseBasis2(B[i], B[j]), p) &&
          _enclosesNot(_encloseBasis2(B[i], p), B[j]) &&
          _enclosesNot(_encloseBasis2(B[j], p), B[i]) &&
          _enclosesWeakAll(_encloseBasis3(B[i], B[j], p), B)) {
        return [B[i], B[j], p];
      }
    }
  }

  throw '_extendBasis ERROR';
}

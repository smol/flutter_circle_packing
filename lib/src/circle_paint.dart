import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_circle_packing/hierarchy_circular_node.dart';

import '../data_node.dart';

const SIZE = 300;

class CirclePaint extends CustomPainter {
  HierarchyCircularNode root;

  CirclePaint({required this.root});

  void paintCircle(HierarchyCircularNode node, Canvas canvas, Size size) {
    var paint = Paint()
      ..color = node.children.isEmpty
          ? const Color.fromARGB(255, 0, 255, 0)
          : const Color.fromARGB(255, 255, 0, 0)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(node.x, node.y), node.r, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // paintCircle(root, canvas);

    root.eachBefore((p0) {
      paintCircle(p0, canvas, size);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

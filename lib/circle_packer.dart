import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_circle_packing/src/circle_paint.dart';
import 'package:flutter_circle_packing/src/hierarchy.dart';
import 'package:flutter_circle_packing/src/pack.dart';

int _descending(a, b) {
  return b < a
      ? -1
      : b > a
          ? 1
          : 0;
}

class CirclePacker extends StatefulWidget {
  final Map<String, dynamic>? root;
  final Size size;

  Hierarchy? _hierarchy;
  Pack? _pack;
  EdgeInsets margin;

  int? Function(Map<String, dynamic>? node)? valueFunction;
  String? Function(Map<String, dynamic>? node)? textlabelFunction;

  CirclePacker({
    Key? key,
    required this.root,
    this.size = const Size(1152, 1152),
    this.valueFunction,
    this.textlabelFunction,
    this.margin = const EdgeInsets.all(double.infinity),
  }) : super(key: key) {
    if (root == null) {
      return;
    }

    _hierarchy = Hierarchy(
      data: root!,
      value: (d) => d.containsKey('size') ? d['size'] as int : 0,
    );
    _hierarchy!.root.sum(
      (p0) => p0.containsKey('size') ? p0['size'] as int : 0,
    );
    _hierarchy!.root.sort((a, b) => _descending(a.value, b.value));

    _pack = Pack(
      node: _hierarchy!.root,
      width: size.width,
      height: size.height,
    );
  }

  @override
  State<CirclePacker> createState() => _CirclePackerState();
}

class _CirclePackerState extends State<CirclePacker> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    debugPrint("TOTO");
  }

  @override
  void initState() {
    super.initState();
  }

  List<Widget> renderTexts() {
    if (widget.textlabelFunction == null) {
      return [];
    }

    List<Widget> widgets = [];
    inspect(widget._pack?.root);
    widget._pack?.root.eachBefore((p0) {
      var text = widget.textlabelFunction!(p0.data);
      if (text != null) {
        var size = p0.r * 2;
        widgets.add(Positioned(
          child: SizedBox(
            width: size,
            height: size,
            // child: Container(
            //   decoration: BoxDecoration(color: Colors.amber),
            // ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          top: p0.y - p0.r,
          left: p0.x - p0.r,
        ));
      }
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    if (widget._pack != null) {
      return InteractiveViewer.builder(
        builder: (context, viewport) => CustomPaint(
          painter: CirclePaint(root: widget._pack!.root),
          size: widget.size,
          // child: Container()
          child: SizedBox(
            width: widget.size.width,
            height: widget.size.height,
            child: Stack(children: renderTexts()),
          ),
        ),
      );
    } else {
      return Container();
    }

    // return widget._pack != null
    //     ? InteractiveViewer(
    //         minScale: 0.01,
    //         maxScale: 5,
    //         clipBehavior: Clip.antiAliasWithSaveLayer,
    //         boundaryMargin: widget.margin,
    //         child: CustomPaint(
    //           painter: CirclePaint(root: widget._pack!.root),
    //           size: widget.size,
    //           child: Stack(children: texts),
    //         ),
    //       )
    //     : Container();
  }
}

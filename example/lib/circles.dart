import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circle_packing/circle_packer.dart';
import 'package:flutter_circle_packing/data_node.dart';

class Circles extends StatefulWidget {
  const Circles({Key? key}) : super(key: key);

  @override
  State<Circles> createState() => _CirclesState();
}

class _CirclesState extends State<Circles> {
  Map<String, dynamic>? _items;

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/flare.json');
    final data = await json.decode(response);
    setState(() {
      _items = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return CirclePacker(
      valueFunction: (i) => i?["size"] as int,
      textlabelFunction: (i) =>
          i?["children"] == null ? i!["name"].toString() : null,
      root: _items,
    );
  }
}

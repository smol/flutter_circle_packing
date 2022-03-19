import 'package:flutter_circle_packing/src/datum.dart';

class DataNode extends Datum {
  String name;

  DataNode({
    required this.name,
    int value = 0,
    children = const <DataNode>[],
  }) : super(children: children, value: value);
}

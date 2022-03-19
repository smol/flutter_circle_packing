abstract class Datum {
  List<Datum> children;

  int value;

  Datum({
    this.value = 0,
    this.children = const [],
  });
}

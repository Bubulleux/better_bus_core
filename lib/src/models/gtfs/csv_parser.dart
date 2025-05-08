import 'dart:io';

class CSVTable extends Iterable {
  late final List<String> keys;
  late List<List<String>> table;

  CSVTable(this.keys, this.table);

  CSVTable.fromFile(File file, [bool firstRawIsTitle = true]) {
    List<String> lines = file.readAsLinesSync();
    if (firstRawIsTitle) {
      String titles = lines.removeAt(0);
      keys = titles.split(",");
    }

    table = [];
    for (String line in lines) {
      table.add(splitLine(line));
    }
  }

  static List<String> splitLine(String line) {
    final quote = line.split("\"");
    return quote
        .asMap()
        .entries
        .map((e) => (e.key % 2) == 0 ? e.value.trim().split(",") : [e.value])
        .fold([], (l, r) {
      if (l.isNotEmpty) {
        final last = l.removeLast();
        l.add(last + r.first);
        l.addAll(r.skip(1));
      } else {
        l.addAll(r);
      }
      return l;
    });
  }

  Map<String, String> getLine(int index) {
    return rowToMap(table[index]);
  }

  Map<String, String> rowToMap(List<String> row) {
    final Map<String, String> out = {};
    for (var i = 0; i < keys.length; i++) {
      out[keys[i]] = i < row.length ? row[i] : "";
    }
    return out;
  }

  @override
  Iterator get iterator => table.map(rowToMap).iterator;
}

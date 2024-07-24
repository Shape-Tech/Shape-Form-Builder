import 'dart:typed_data';

class FileDataModel {
  final String name;
  final String mime;
  final int bytes;
  final String path;
  final Uint8List data;

  FileDataModel(
      {required this.name,
      required this.mime,
      required this.bytes,
      required this.path,
      required this.data});

  String get size {
    final kb = bytes / 1024;
    final mb = kb / 1024;

    return mb > 1
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
  }
}

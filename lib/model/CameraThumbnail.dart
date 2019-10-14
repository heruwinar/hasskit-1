import 'dart:typed_data';

class CameraThumbnail {
  final String entityId;
  final DateTime receivedDateTime;
  final Uint8List content;

  CameraThumbnail({
    this.entityId,
    this.receivedDateTime,
    this.content,
  });
}

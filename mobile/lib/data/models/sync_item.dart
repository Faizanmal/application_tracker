import 'package:hive/hive.dart';

part 'sync_item.g.dart';

/// Sync operation types
@HiveType(typeId: 10)
enum SyncOperation {
  @HiveField(0)
  create,
  @HiveField(1)
  update,
  @HiveField(2)
  delete,
}

/// Represents an item in the sync queue
@HiveType(typeId: 2)
class SyncItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final SyncOperation operation;

  @HiveField(2)
  final String entityType;

  @HiveField(3)
  final String entityId;

  @HiveField(4)
  final Map<String, dynamic> data;

  @HiveField(5)
  final DateTime timestamp;

  @HiveField(6)
  final int attempts;

  SyncItem({
    required this.id,
    required this.operation,
    required this.entityType,
    required this.entityId,
    required this.data,
    required this.timestamp,
    this.attempts = 0,
  });

  SyncItem copyWith({
    String? id,
    SyncOperation? operation,
    String? entityType,
    String? entityId,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    int? attempts,
  }) {
    return SyncItem(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      attempts: attempts ?? this.attempts,
    );
  }

  @override
  String toString() {
    return 'SyncItem(id: $id, operation: $operation, entityType: $entityType, entityId: $entityId, attempts: $attempts)';
  }
}

/// Hive adapter for SyncItem
class SyncItemAdapter extends TypeAdapter<SyncItem> {
  @override
  final int typeId = 2;

  @override
  SyncItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncItem(
      id: fields[0] as String,
      operation: fields[1] as SyncOperation,
      entityType: fields[2] as String,
      entityId: fields[3] as String,
      data: Map<String, dynamic>.from(fields[4] as Map),
      timestamp: fields[5] as DateTime,
      attempts: fields[6] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, SyncItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.operation)
      ..writeByte(2)
      ..write(obj.entityType)
      ..writeByte(3)
      ..write(obj.entityId)
      ..writeByte(4)
      ..write(obj.data)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.attempts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// Hive adapter for SyncOperation enum
class SyncOperationAdapter extends TypeAdapter<SyncOperation> {
  @override
  final int typeId = 10;

  @override
  SyncOperation read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncOperation.create;
      case 1:
        return SyncOperation.update;
      case 2:
        return SyncOperation.delete;
      default:
        return SyncOperation.create;
    }
  }

  @override
  void write(BinaryWriter writer, SyncOperation obj) {
    switch (obj) {
      case SyncOperation.create:
        writer.writeByte(0);
        break;
      case SyncOperation.update:
        writer.writeByte(1);
        break;
      case SyncOperation.delete:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncOperationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

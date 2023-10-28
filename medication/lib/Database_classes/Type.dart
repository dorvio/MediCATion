import 'package:flutter/foundation.dart';

@immutable
class Type {
  String typeId;
  String type;

  Type({
    required this.typeId,
    required this.type,
  });

  Type copyWith({
    String? typeId,
    String? type,
  }) {
    return Type(
      typeId : typeId ?? this.typeId,
      type : type ?? this.type,
    );
  }
}
import 'package:json_annotation/json_annotation.dart';

enum ProfileType {
  @JsonValue(0)
  passenger,
  @JsonValue(1)
  driver,
}

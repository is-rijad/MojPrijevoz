import 'package:json_annotation/json_annotation.dart';

enum FareOfferSide {
  @JsonValue(0)
  passenger,
  @JsonValue(1)
  driver,
}

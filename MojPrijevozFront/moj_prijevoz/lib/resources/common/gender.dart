import 'package:json_annotation/json_annotation.dart';

enum Gender {
  @JsonValue(0)
  female,
  @JsonValue(1)
  male,
}

Map<Gender, String> translatedGenders = {
  Gender.female: "Ženski",
  Gender.male: "Muški",
};

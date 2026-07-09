import 'package:json_annotation/json_annotation.dart';

enum TransactionSide {
  @JsonValue(0)
  credit,
  @JsonValue(1)
  debit,
}

final Map<TransactionSide, String> transactionSideMap = {
  TransactionSide.credit: "Izlazna",
  TransactionSide.debit: "Ulazna",
};

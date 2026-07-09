import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/transaction_side.dart';
import 'package:moj_prijevoz_admin/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/transaction/all_transactions_response.dart';

part 'transaction_response.g.dart';

@JsonSerializable()
class TransactionResponse extends AllTransactionsResponse {
  TransactionResponse({
    required super.id,
    required super.fareId,
    required super.side,
    required super.amount,
    super.postedAt,
    required super.createdAt,
    super.fare,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);
}

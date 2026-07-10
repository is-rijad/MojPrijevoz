import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/transaction_side.dart';
import 'package:moj_prijevoz_admin/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'all_transactions_response.g.dart';

@JsonSerializable()
class AllTransactionsResponse extends JsonResponse {
  @override
  final int id;
  final int fareId;
  final TransactionSide side;
  final double amount;
  final double? feeAmount;
  final DateTime? postedAt;
  final DateTime createdAt;
  final FareResponse? fare;

  AllTransactionsResponse({
    required this.id,
    required this.fareId,
    required this.side,
    required this.amount,
    this.postedAt,
    required this.createdAt,
    this.fare,
    this.feeAmount,
  });

  factory AllTransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$AllTransactionsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AllTransactionsResponseToJson(this);
}

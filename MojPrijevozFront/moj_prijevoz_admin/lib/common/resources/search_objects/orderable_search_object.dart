import 'package:moj_prijevoz_admin/common/resources/search_objects/base_search_object.dart';

abstract class OrderableSearchObject extends BaseSearchObject {
  String? orderBy;
  String? orderDirection;

  OrderableSearchObject({
    required super.page,
    required super.pageSize,
    this.orderBy,
    this.orderDirection,
  });
}

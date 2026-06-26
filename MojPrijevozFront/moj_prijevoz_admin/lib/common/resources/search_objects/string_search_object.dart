import 'package:moj_prijevoz_admin/common/resources/search_objects/orderable_search_object.dart';

abstract class StringSearchObject extends OrderableSearchObject {
  String? contains;
  StringSearchObject({
    this.contains,
    required super.page,
    required super.pageSize,
    super.orderBy,
    super.orderDirection,
  });
}

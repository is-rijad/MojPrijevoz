import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';

abstract class StringSearchObject extends BaseSearchObject {
  String? contains;
  StringSearchObject({
    this.contains,
    required super.page,
    required super.pageSize,
  });
}

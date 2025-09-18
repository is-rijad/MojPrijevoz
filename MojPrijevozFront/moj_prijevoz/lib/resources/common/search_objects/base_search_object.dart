import 'package:moj_prijevoz/utils/json_parser.dart';

abstract class BaseSearchObject extends JsonParsable {
  int page;
  int pageSize;
  String? contains;

  BaseSearchObject({this.page = 1, this.pageSize = 10, this.contains});
}

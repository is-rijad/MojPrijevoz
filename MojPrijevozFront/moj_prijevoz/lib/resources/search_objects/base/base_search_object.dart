import 'package:moj_prijevoz/utils/json_parser.dart';

abstract class BaseSearchObject extends JsonParsable {
  int page;
  final int pageSize;

  BaseSearchObject({this.page = 1, this.pageSize = 10});
}

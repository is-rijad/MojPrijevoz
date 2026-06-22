import 'package:moj_prijevoz_admin/utils/json_parser.dart';

abstract class BaseSearchObject extends JsonParsable {
  int page;
  final int pageSize;

  BaseSearchObject({required this.page, required this.pageSize});
}

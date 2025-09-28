import 'package:moj_prijevoz/utils/json_parser.dart';

class TPlaceholderRequest implements JsonRequest {
  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class TPlaceholderResponse implements JsonResponse {
  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  int id = -1;
}

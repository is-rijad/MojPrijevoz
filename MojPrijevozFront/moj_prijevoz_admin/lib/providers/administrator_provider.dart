import 'package:moj_prijevoz_admin/common/providers/base_provider.dart';
import 'package:moj_prijevoz_admin/resources/requests/administrator/administrator_upsert_request.dart';
import 'package:moj_prijevoz_admin/resources/responses/administrator/administrator_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/administrator/all_administrator_response.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/administrator/administrator_search_object.dart';

class AdministratorProvider
    extends
        BaseProvider<
          AllAdministratorResponse,
          AdministratorResponse,
          AdministratorSearchObject,
          AdministratorUpsertRequest,
          AdministratorUpsertRequest
        > {
  AdministratorProvider() : super(providerName: "administrator");
}

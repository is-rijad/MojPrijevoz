import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/administrator_role.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/account_status.dart';
import 'package:moj_prijevoz_admin/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz_admin/common/widgets/tables/paginated_table.dart';
import 'package:moj_prijevoz_admin/pages/admins/one_admin_page.dart';
import 'package:moj_prijevoz_admin/providers/administrator_provider.dart';
import 'package:moj_prijevoz_admin/resources/responses/administrator/administrator_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/administrator/all_administrator_response.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/administrator/administrator_search_object.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';

class AdminsPage extends StatefulWidget {
  const AdminsPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminsPageState();
}

class _AdminsPageState extends RouteAwareState<AdminsPage> {
  _AdminsPageState() : super(action: DrawerMenuAction.admins);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(body: _build(context), appBarTitle: "Administratori");
  }

  Widget _build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PrimaryButton(
                text: "Dodajte administratora",
                onPressed: () async => await _navigateToAddAdminPage(),
              ),
            ],
          ),
        ),
        SizedBox(
          height: context.screenHeight * 0.8,
          width: context.screenWidth,
          child:
              PaginatedTable<
                AllAdministratorResponse,
                AdministratorResponse,
                AdministratorProvider,
                AdministratorSearchObject
              >(
                searchObject: AdministratorSearchObject(page: 1, pageSize: 10),
                header: <String, String?>{
                  "Ime": "FirstName",
                  "Prezime": "LastName",
                  "Email": "Email",
                  "Korisničko ime": "Username",
                  "Status": "Status",
                  "Uloga": "Role",
                },

                items: [
                  (i) => Text(i.firstName),
                  (i) => Text(i.lastName),
                  (i) => Text(i.email),
                  (i) => Text(i.username),
                  (i) => Text(accountStatusMap[i.status]!),
                  (i) => Text(administratorRoleFieldMap[i.role]!),
                ],
                onTap: (i) async =>
                    await Constants.navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (context) => OneAdminPage(userId: i!.id),
                      ),
                    ),
              ),
        ),
      ],
    );
  }

  Future _navigateToAddAdminPage() async {
    await Constants.navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => OneAdminPage(userId: null)),
    );
  }
}

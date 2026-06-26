import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/account_status.dart';
import 'package:moj_prijevoz_admin/common/widgets/tables/paginated_table.dart';
import 'package:moj_prijevoz_admin/pages/users/one_user_page.dart';
import 'package:moj_prijevoz_admin/providers/users_provider.dart';
import 'package:moj_prijevoz_admin/resources/responses/users/user_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/users/users_response.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/users/users_search_object.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<StatefulWidget> createState() => _UsersPageState();
}

class _UsersPageState extends RouteAwareState<UsersPage> {
  _UsersPageState() : super(action: DrawerMenuAction.users);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(body: _buildBody(context), appBarTitle: "Korisnici");
  }

  Widget _buildBody(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.85,
      width: context.screenWidth,
      child:
          PaginatedTable<
            UsersResponse,
            UserResponse,
            UsersProvider,
            UsersSearchObject
          >(
            searchObject: UsersSearchObject(page: 1, pageSize: 10),
            header: <String, String?>{
              "Ime": "FirstName",
              "Prezime": "LastName",
              "Email": "Email",
              "Korisničko ime": "Username",
              "Status": "Status",
              "Broj mobitela": null,
              "Registrovan": "RegisteredAt",
            },

            items: [
              (i) => Text(i.firstName),
              (i) => Text(i.lastName),
              (i) => Text(i.email),
              (i) => Text(i.username),
              (i) => Text(accountStatusMap[i.status]!),
              (i) => Text(i.phoneNumber),
              (i) => Text(
                "${context.getLocalizedDate(i.registeredAt)} ${context.getLocalizedTime(i.registeredAt)}",
              ),
            ],
            onTap: (i) async => await Constants.navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => OneUserPage(userId: i!.id),
              ),
            ),
          ),
    );
  }
}

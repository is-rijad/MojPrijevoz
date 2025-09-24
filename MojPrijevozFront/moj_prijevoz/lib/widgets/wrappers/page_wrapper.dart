import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/access_token_handler.dart';
import 'package:moj_prijevoz/common/profile_dropdown_action.dart';
import 'package:moj_prijevoz/pages/login.dart';
import 'package:moj_prijevoz/pages/my_driver_profile.dart';
import 'package:moj_prijevoz/pages/my_profile.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';
import 'package:moj_prijevoz/resources/common/access_token_payload.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/profile_dropdown/profile_dropdown_item.dart';
import 'package:moj_prijevoz/widgets/wrappers/app_overlay.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';

class PageWrapper extends StatefulWidget {
  final Widget body;
  final Widget? appBarTitle;

  const PageWrapper({super.key, required this.body, this.appBarTitle});

  @override
  State<StatefulWidget> createState() => _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> {
  final UIProvider _uiProvider = GetIt.I<UIProvider>();
  final _avatarKey = GlobalKey();
  // TODO: create event to refresh payload
  late final AccessTokenPayload _accessTokenPayload;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _initState() async {
    _accessTokenPayload = await AccessTokenHandler.getPayload();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(
      buildFunction: (context) =>
          Scaffold(appBar: _buildAppBar(context), body: widget.body),
      futureFunction: _initState,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: widget.appBarTitle,
      actions: [_buildProfileIcon(context)],
    );
  }

  Widget _buildProfileIcon(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.5).copyWith(right: 10),
      child: GestureDetector(
        key: _avatarKey,
        onTap: () => _showDropdown(context),
        child: Avatar(radius: 20, user: _accessTokenPayload),
      ),
    );
  }

  Future<void> _showDropdown(BuildContext context) async {
    final RenderBox renderBox =
        _avatarKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _uiProvider.profileDropdownAction = await showMenu(
      context: context,
      color: AppOverlay.secondaryColor,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height + 7,
        offset.dx + size.width,
        offset.dy + size.height,
      ),
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 300),
      ),
      items: [
        ProfileDropdownItem(
          text: "Moj profil",
          value: ProfileDropdownAction.profile,
        ),
        ProfileDropdownItem(
          text: _accessTokenPayload.driverProfileId != null
              ? "Moj profil (vozač)"
              : "Postani vozač",
          value: ProfileDropdownAction.driver,
        ),
        ProfileDropdownItem(
          text: "Odjava",
          value: ProfileDropdownAction.logout,
        ),
      ],
    );
    switch (_uiProvider.profileDropdownAction) {
      case ProfileDropdownAction.profile:
        if (!context.mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyProfile()),
        );
        break;
      case ProfileDropdownAction.driver:
        if (!context.mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyDriverProfile()),
        );
        break;
      case ProfileDropdownAction.logout:
        await AccessTokenHandler.logout();
        if (!context.mounted) return;
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        break;
      default:
    }

    if (mounted) {
      setState(() {
        _uiProvider.profileDropdownAction = null;
      });
    }
  }
}

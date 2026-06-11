import 'package:easy_stars/easy_stars.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/common/profile_dropdown_action.dart';
import 'package:moj_prijevoz/pages/login.dart';
import 'package:moj_prijevoz/pages/my_driver_profile/my_driver_profile.dart';
import 'package:moj_prijevoz/pages/my_fares/my_fares_page.dart';
import 'package:moj_prijevoz/pages/my_profile.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/notification_provider.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';
import 'package:moj_prijevoz/resources/common/access_token_payload.dart';
import 'package:moj_prijevoz/resources/responses/notification/notification_response.dart';
import 'package:moj_prijevoz/resources/search_objects/notification/notification_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/profile_dropdown/profile_dropdown_item.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/widgets/wrappers/app_overlay.dart';
import 'package:provider/provider.dart';

class PageWrapper extends StatefulWidget {
  final Widget body;
  final String? appBarTitle;

  const PageWrapper({super.key, required this.body, this.appBarTitle});

  @override
  State<StatefulWidget> createState() => _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> {
  final UIProvider _uiProvider = GetIt.I<UIProvider>();
  final _avatarKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _notificationSearchObject = NotificationSearchObject(
    page: 1,
    pageSize: 15,
  );
  final _notificationScrollController = ScrollController();
  bool _isLoading = false;

  late AccessTokenPayload _accessTokenPayload;

  @override
  void didChangeDependencies() {
    _accessTokenPayload = context.watch<AuthProvider>().accessTokenPayload;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _notificationScrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_notificationScrollController.position.pixels >=
        _notificationScrollController.position.maxScrollExtent - 100) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    final provider = context.read<NotificationProvider>();
    if (_isLoading || !provider.searchResult.hasMore) return;

    setState(() {
      _isLoading = true;
    });

    await provider.fetchData(_notificationSearchObject);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _notificationScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: widget.body,
        key: _scaffoldKey,
        drawer: _buildDrawer(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      automaticallyImplyLeading: false,
      title: TextTitleSmall(widget.appBarTitle ?? ""),
      actions: [_buildProfileIcon(context), _buildDrawerIcon(context)],
      actionsPadding: EdgeInsets.all(8),
    );
  }

  Widget _buildProfileIcon(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, value, _) {
        return Padding(
          padding: EdgeInsets.all(2.5).copyWith(right: 10),
          child: GestureDetector(
            key: _avatarKey,
            onTap: () => _showDropdown(context),
            child: Avatar(
              radius: 30,
              fontSize: 8,
              user: value.accessTokenPayload,
              showAccountStatus: true,
            ),
          ),
        );
      },
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
          text: "Moje vožnje",
          value: ProfileDropdownAction.fares,
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
      case ProfileDropdownAction.fares:
        if (!context.mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyFaresPage()),
        );
        break;
      case ProfileDropdownAction.logout:
        setState(() {
          _uiProvider.profileDropdownAction = null;
        });
        if (!context.mounted) return;
        await context.read<AuthProvider>().logout();
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          return ListView.builder(
            controller: _notificationScrollController,
            padding: EdgeInsets.zero,
            itemCount:
                provider.searchResult.items.length + (_isLoading ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return DrawerHeader(
                  decoration: BoxDecoration(color: context.primaryColor),
                  child: TextTitleLarge('Notifikacije'),
                );
              }
              if (index == provider.searchResult.items.length && _isLoading) {
                return CircularProgressIndicator();
              }
              var i = provider.searchResult.items[index];
              return ListTile(
                title: !i.isRead
                    ? TextBodyMedium(i.message, fontWeight: FontWeight(900))
                    : TextBodyMedium(i.message),
                onTap: () async => await _onTap(i),
              );
            },
          );
        },
      ),
    );
  }

  Future _onTap(NotificationResponse i) async {
    _scaffoldKey.currentState?.closeDrawer();
    await context.read<NotificationProvider>().update(i.id, null);
    i.isRead = true;
    if (!mounted) return;
    context.read<NotificationProvider>().updateLocally(i);
    await GetIt.I<UIProvider>().handleNavigationFromNotification({
      "Type": i.type,
      "FareId": i.fareId,
      "Side": i.side,
      "IsRead": i.isRead,
      "RatingId": i.ratingId,
    });
  }

  Widget _buildDrawerIcon(BuildContext context) {
    return IconButton(
      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      icon: Icon(Icons.notifications),
    );
  }
}

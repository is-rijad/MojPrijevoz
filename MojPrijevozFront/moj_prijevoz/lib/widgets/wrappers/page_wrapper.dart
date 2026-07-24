import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/common/profile_dropdown_action.dart';
import 'package:moj_prijevoz/pages/login.dart';
import 'package:moj_prijevoz/pages/my_driver_profile/my_driver_profile.dart';
import 'package:moj_prijevoz/pages/my_fares/my_fares_page.dart';
import 'package:moj_prijevoz/pages/my_profile.dart';
import 'package:moj_prijevoz/common/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/notification_provider.dart';
import 'package:moj_prijevoz/common/providers/ui_provider.dart';
import 'package:moj_prijevoz/common/resources/access_token_payload.dart';
import 'package:moj_prijevoz/resources/responses/notification/notification_response.dart';
import 'package:moj_prijevoz/resources/search_objects/notification/notification_search_object.dart';
import 'package:moj_prijevoz/common/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/profile_dropdown/profile_dropdown_item.dart';
import 'package:moj_prijevoz/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/common/wrappers/app_overlay.dart';
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
  bool _isShowingDropdown = false;

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
        endDrawer: _buildDrawer(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Constants.navigatorKey.currentState?.canPop() ?? false
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Constants.navigatorKey.currentState?.pop(),
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
    if (_isShowingDropdown) return;
    _isShowingDropdown = true;
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
    _isShowingDropdown = false;

    switch (_uiProvider.profileDropdownAction) {
      case ProfileDropdownAction.profile:
        if (!context.mounted) return;
        await Constants.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => MyProfile()),
        );
        break;
      case ProfileDropdownAction.driver:
        if (!context.mounted) return;
        await Constants.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => MyDriverProfile()),
        );
        break;
      case ProfileDropdownAction.fares:
        if (!context.mounted) return;
        await Constants.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => MyFaresPage()),
        );
        break;
      case ProfileDropdownAction.logout:
        _uiProvider.startLoading();
        setState(() {
          _uiProvider.profileDropdownAction = null;
        });
        if (!context.mounted) return;
        await context.read<AuthProvider>().logout();
        if (!context.mounted) return;
        _uiProvider.stopLoading();
        await Constants.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
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
          final items = provider.searchResult.items;
          final isEmpty = items.isEmpty;
          final itemCount =
              1 +
              (isEmpty ? 1 : items.length) +
              (_isLoading && !isEmpty ? 1 : 0);

          return ListView.builder(
            controller: _notificationScrollController,
            padding: EdgeInsets.zero,
            itemCount: itemCount,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return SizedBox(
                  height: 60,
                  child: DrawerHeader(
                    padding: const EdgeInsetsGeometry.directional(
                      top: 12,
                      start: 12,
                    ),
                    decoration: BoxDecoration(color: context.primaryColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const TextTitleLarge('Notifikacije'),
                        IconButton(
                          onPressed: () =>
                              _scaffoldKey.currentState?.closeEndDrawer(),
                          icon: Icon(
                            Icons.close,
                            color: context.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: TextBodyMedium(
                      "Nemate notifikacija!",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              if (index == items.length + 1) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              var i = items[index - 1];
              return ListTile(
                title: !i.isRead
                    ? Badge(
                        child: TextBodyMedium(
                          i.message,
                          fontWeight: FontWeight(1000),
                        ),
                      )
                    : TextBodyMedium(i.message),
                onTap: () async => await _onTap(i),
                trailing: ElevatedButton(
                  onPressed: () async => await _markAsReadNotification(i),
                  child: const Text("Označi kao pročitano"),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future _markAsReadNotification(NotificationResponse i) async {
    await context.read<NotificationProvider>().update(i.id, null);
    i.isRead = true;
    if (!mounted) return;
    context.read<NotificationProvider>().updateLocally(i);
  }

  Future _onTap(NotificationResponse i) async {
    _scaffoldKey.currentState?.closeEndDrawer();
    await _markAsReadNotification(i);
    context.read<NotificationProvider>().updateLocally(i);
    await GetIt.I<UIProvider>().handleNavigationFromNotification({
      "Type": i.type,
      "FareId": i.fareId,
      "Side": i.side,
      "IsRead": i.isRead,
      "RatingId": i.ratingId,
    });
    if (mounted) setState(() {});
  }

  Widget _buildDrawerIcon(BuildContext context) {
    final child = IconButton(
      onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
      icon: Icon(Icons.notifications),
    );
    if (context.watch<NotificationProvider>().hasUnread) {
      return Badge(child: child);
    }
    return child;
  }
}

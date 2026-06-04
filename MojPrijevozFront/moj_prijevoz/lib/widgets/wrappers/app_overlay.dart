import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';
import 'package:moj_prijevoz/widgets/texts/text_theme.dart';

class AppOverlay extends StatelessWidget {
  final UIProvider _uiProvider = GetIt.I<UIProvider>();
  final Widget child;

  static const primaryColor = Color(0xFF4A91D1);
  static const secondaryColor = Color(0xFFD1E9FE);

  AppOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.topCenter,
      fit: StackFit.expand,
      children: [
        RepaintBoundary(child: _buildBackgroundImage(context)),
        _buildApp(context),
        _buildLoadingOverlay(context),
      ],
    );
  }

  MaterialApp _buildApp(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moj Prijevoz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
        ),
        useMaterial3: true,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
        appBarTheme: AppBarTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(150)),
          ),
          toolbarHeight: 60,
          backgroundColor: primaryColor,
          foregroundColor: secondaryColor,
          iconTheme: const IconThemeData(color: secondaryColor),
          titleTextStyle: const TextStyle(color: secondaryColor, fontSize: 24),
        ),
        scaffoldBackgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: primaryColor),
        fontFamily: "Inter",
        textTheme: textTheme,
      ),
      home: child,
      scaffoldMessengerKey: Constants.messengerKey,
      navigatorKey: Constants.navigatorKey,
    );
  }

  ValueListenableBuilder<bool> _buildLoadingOverlay(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _uiProvider.isLoading,
      builder: (context, loading, _) {
        if (!loading) return const SizedBox.shrink();
        return buildLoadingContainer(context);
      },
    );
  }

  static Widget buildLoadingContainer(BuildContext context) {
    return Container(
      color: context.secondaryColor.withAlpha(125),
      child: const Center(
        child: CircularProgressIndicator(color: AppOverlay.primaryColor),
      ),
    );
  }

  Widget _buildBackgroundImage(BuildContext context) {
    return Container(
      width: context.screenWidth,
      decoration: BoxDecoration(
        color: const Color(0xFFACD8FF),
        image: DecorationImage(
          image: AssetImage("images/background.png"),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low,
        ),
      ),
    );
  }
}

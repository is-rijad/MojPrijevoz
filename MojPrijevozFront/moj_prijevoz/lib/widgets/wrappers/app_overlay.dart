import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';
import 'package:moj_prijevoz/widgets/texts/text_theme.dart';

class AppOverlay extends StatelessWidget {
  final UIProvider _uiProvider = GetIt.I<UIProvider>();
  final Widget child;

  static const primaryColor = Color(0xFF3F8ED4);
  static const secondaryColor = Color(0xFFF1F5FE);

  AppOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.topCenter,
      children: [_buildApp(context), _buildLoadingOverlay(context)],
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
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: secondaryColor,
          iconTheme: const IconThemeData(color: secondaryColor),
          titleTextStyle: const TextStyle(color: secondaryColor, fontSize: 24),
        ),
        iconTheme: const IconThemeData(color: primaryColor),
        fontFamily: "Roboto",
        textTheme: textTheme,
      ),
      home: child,
      scaffoldMessengerKey: Constants.messengerKey,
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
}

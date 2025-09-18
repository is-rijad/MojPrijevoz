import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/pages/login.dart';
import 'package:moj_prijevoz/providers/loading_provider.dart';

class AppOverlay extends StatelessWidget {
  late final LoadingProvider _loadingProvider;

  AppOverlay({super.key}) {
    _loadingProvider = GetIt.I<LoadingProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.topCenter,
      children: [
        MaterialApp(
          title: 'Moj Prijevoz',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.black,
              primary: const Color(0xFF3F8ED4),
              secondary: const Color(0xFFF1F5FE),
            ),
            useMaterial3: true,
          ),
          home: LoginPage(),
          scaffoldMessengerKey: Constants.messengerKey,
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _loadingProvider.isLoading,
          builder: (context, loading, _) {
            if (!loading) return const SizedBox.shrink();
            final backgroundColor = Theme.of(context).colorScheme.secondary;

            return Container(
              color: backgroundColor.withAlpha(50),
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ],
    );
  }
}

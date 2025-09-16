import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/providers/loading_provider.dart';

class AppOverlay extends StatelessWidget {
  final Widget child;
  late final LoadingProvider _loadingProvider;

  AppOverlay({super.key, required this.child}) {
    _loadingProvider = GetIt.I<LoadingProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          child,
          ValueListenableBuilder<bool>(
            valueListenable: _loadingProvider.isLoading,
            builder: (context, loading, _) {
              if (!loading) return const SizedBox.shrink();
              return Container(
                color: Colors.black.withAlpha(125),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

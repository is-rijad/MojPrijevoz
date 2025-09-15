import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/services/http_service.dart';

class AppOverlay extends StatelessWidget {
  final Widget child;
  late final HttpService _httpService;

  AppOverlay({super.key, required this.child}) {
    _httpService = GetIt.I<HttpService>();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        ValueListenableBuilder<bool>(
          valueListenable: _httpService.isLoading,
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
    );
  }
}

import 'package:flutter/material.dart';

class AlertDialogContent extends StatelessWidget {
  final Widget child;
  final ValueNotifier<String?>? errorMessageValueNotifier;

  const AlertDialogContent({
    super.key,
    required this.child,
    required this.errorMessageValueNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        ValueListenableBuilder<String?>(
          valueListenable:
              errorMessageValueNotifier ?? ValueNotifier<String?>(null),
          builder: (context, value, _) {
            if (value != null) {
              Future.delayed(
                Duration(seconds: 3),
                () => errorMessageValueNotifier?.value = null,
              );
              return Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(value, style: TextStyle(color: Colors.white)),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

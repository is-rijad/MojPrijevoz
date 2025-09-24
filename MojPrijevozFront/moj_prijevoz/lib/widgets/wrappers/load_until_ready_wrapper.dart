import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:moj_prijevoz/common/build_helper.dart';

class LoadUntilReadyWrapper extends StatefulWidget {
  final Widget Function(BuildContext) buildFunction;
  final Future<bool> Function() futureFunction;

  const LoadUntilReadyWrapper({
    super.key,
    required this.buildFunction,
    required this.futureFunction,
  });

  @override
  State<StatefulWidget> createState() => _LoadUntilReadyWrapperState();
}

class _LoadUntilReadyWrapperState extends State<LoadUntilReadyWrapper> {
  Future<bool>? _future;

  @override
  void initState() {
    super.initState();
    _future = widget.futureFunction();
  }

  @override
  Widget build(BuildContext context) {
    if (_future == null) {
      return Container(
        color: BuildHelper.getSecondaryColor(context),
        width: BuildHelper.getScreenWidth(context),
        height: BuildHelper.getScreenHeight(context),
      );
    }
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return widget.buildFunction(context);
        }
        if (snapshot.hasError) {
          log("ERROR IN FUTURE BUILDER => ${snapshot.error}");
        }
        return Container(
          color: BuildHelper.getSecondaryColor(context),
          width: BuildHelper.getScreenWidth(context),
          height: BuildHelper.getScreenHeight(context),
        );
      },
    );
  }
}

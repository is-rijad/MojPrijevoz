import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/env.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/notification_provider.dart';
import 'package:moj_prijevoz/resources/responses/notification/notification_response.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:provider/provider.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class SignalrProvider implements Disposable {
  final String _hubBaseUrl = "${Environment.apiUrl.split("api")[0]}hubs/";
  late HubConnection _hubNotificationsConnection;

  void initialize() {
    _hubNotificationsConnection = HubConnectionBuilder()
        .withUrl(
          "${_hubBaseUrl}notifications",
          options: HttpConnectionOptions(
            accessTokenFactory: () async => await AuthProvider.getAccessToken(),
          ),
        )
        .build();
    _hubNotificationsConnection.on("new_notification", (args) {
      try {
        final data = args![0] as Map<String, dynamic>;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Constants.messengerKey.currentState?.showSnackBar(
            SuccessSnackBar(message: data["message"]),
          );

          Constants.messengerKey.currentContext
              ?.read<NotificationProvider>()
              .insertLocally(NotificationResponse.fromJson(data), index: 0);
        });
      } on Exception catch (e) {}
    });

    _hubNotificationsConnection.on(
      'error',
      (args) => print('Hub error: $args'),
    );

    _hubNotificationsConnection.start();
  }

  @override
  Future<dynamic> onDispose() async {
    await _hubNotificationsConnection.stop();
  }
}

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/providers/http_provider.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';
import 'package:moj_prijevoz/resources/requests/notification/subscribe_to_fcm_request.dart';

class NotificationProvider {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final HttpProvider _httpProvider = GetIt.I<HttpProvider>();
  final UIProvider _uiProvider = GetIt.I<UIProvider>();

  Future<void> initialize() async {
    await _requestPermission();
    await _initToken();
    _listenTokenRefresh();
    _setupHandlers();
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  Future<void> _initToken() async {
    final token = await _messaging.getToken();

    if (token != null) {
      await _sendTokenToBackend(token);
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    await _httpProvider.post<SubscribeToFcmRequest, void>(
      'fcm/',
      SubscribeToFcmRequest(
        token: token,
        platform: Platform.isAndroid ? 'android' : 'ios',
      ),
    );
  }

  void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) {
      _sendTokenToBackend(newToken);
    });
  }

  Future<void> logout() async {
    await _messaging.deleteToken();
    await _deleteTokenOnBackend();
  }

  Future<void> _deleteTokenOnBackend() async {
    await _httpProvider.delete('fcm/', null);
  }

  void _setupHandlers() {
    _handleBackgroundTap();
    _handleTerminatedTap();
  }

  void _handleBackgroundTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _uiProvider.handleNavigationFromNotification(message.data);
    });
  }

  Future<void> _handleTerminatedTap() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _uiProvider.handleNavigationFromNotification(message.data);
    }
  }
}

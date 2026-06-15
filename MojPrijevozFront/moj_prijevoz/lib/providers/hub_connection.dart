import 'package:moj_prijevoz/common/env.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:signalr_netcore/signalr_client.dart';

class HubConnectionProvider {
  HubConnection? _hubConnection;
  HubConnection? get hubConnection => _hubConnection;
  final List<Function(List<Object?>?)> _subscribers = [];

  Future<void> init() async {
    if (_hubConnection == null) {
      _initializeHubConnection();
    }

    if (_hubConnection!.state != HubConnectionState.Disconnected) {
      await _hubConnection!.stop();
    }

    try {
      await _hubConnection!.start();
    } catch (e) {
      return;
    }
    _init("NewNotification");
    _init("ReceiveLocation");
    _init("LocationRequested");
  }

  void _init(String methodName) {
    _hubConnection!.off(methodName);
    _hubConnection!.on(methodName, (args) {
      for (var subscriber in _subscribers) {
        subscriber(args);
      }
    });
  }

  void subscribe(void Function(List<Object?>? data) callback) {
    _subscribers.add(callback);
  }

  void unsubscribe(void Function(List<Object?>? data) callback) {
    _subscribers.remove(callback);
  }

  void _initializeHubConnection() {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          '${Environment.apiUrl.substring(0, Environment.apiUrl.indexOf("/api"))}/actionhub',
          options: HttpConnectionOptions(
            accessTokenFactory: () async {
              return await AuthProvider.getAccessToken();
            },
          ),
        )
        .withAutomaticReconnect()
        .build();
  }

  Future<void> stop() async {
    if (_hubConnection != null &&
        _hubConnection!.state != HubConnectionState.Disconnected) {
      await _hubConnection!.stop();
      print("Hub stopped: ${_hubConnection!.state}");
    }
  }
}

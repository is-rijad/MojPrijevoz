import 'package:moj_prijevoz/common/env.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:signalr_netcore/signalr_client.dart';

class HubConnectionProvider {
  HubConnection? _hubConnection;
  HubConnection? get hubConnection => _hubConnection;
  final Map<String, Function(List<Object?>?)> _subscribers = {};

  Future<void> init() async {
    await stop();

    _initializeHubConnection();
    _init("NewNotification");
    _init("ReceiveLocation");
    _init("LocationRequested");

    try {
      await _hubConnection!.start();
      print("Connection started successfully!");
    } on Exception catch (e) {
      print("Error while establishing connection => $e");
      return;
    }

    _hubConnection!.onclose(({Exception? error}) {
      if (error != null) {
        print('Connection closed with error: $error');
      } else {
        print('Connection closed successfully.');
      }
    });
  }

  void _init(String methodName) {
    _hubConnection!.off(methodName);
    _hubConnection!.on(methodName, (args) {
      for (var subscriber in _subscribers.entries.where(
        (it) => it.key == methodName,
      )) {
        subscriber.value(args);
      }
    });
  }

  void subscribe(
    String methodName,
    void Function(List<Object?>? data) callback,
  ) {
    _subscribers.addAll({methodName: callback});
  }

  void unsubscribe(String methodName) {
    _subscribers.remove(methodName);
  }

  void _initializeHubConnection() {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          Environment.hubBaseUrl,
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
    }
  }
}

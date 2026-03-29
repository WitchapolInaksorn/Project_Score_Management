import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  late HubConnection connection;
  bool _isConnected = false;

  final Set<Function(dynamic)> _listeners = {};

  void addListener(Function(dynamic) callback) {
    _listeners.add(callback); // ✅ จะไม่ซ้ำ
  }

  void removeListener(Function(dynamic) callback) {
    _listeners.remove(callback);
  }

  Future<void> connect({required String studentId}) async {
    if (_isConnected) {
      print("⚠️ already connected");
      return;
    }

    connection =
        HubConnectionBuilder()
            .withUrl("http://10.0.2.2:5155/notifyHub")
            .build();

    connection.on("ReceiveNotification", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        print("✅ MESSAGE: ${arguments[0]}");
        print("👂 listeners count: ${_listeners.length}");
        for (var listener in _listeners) {
          listener(arguments[0]);
        }
      }
    });

    await connection.start();
    print("✅ SignalR Connected");

    await connection.invoke("JoinGroup", args: [studentId]);

    _isConnected = true;
  }

  Future<void> disconnect() async {
    await connection.stop();
    _isConnected = false;
  }
}

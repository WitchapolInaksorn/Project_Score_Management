import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  late HubConnection connection;

  Future<void> connect({
    required String studentId,
    required Function(dynamic data) onReceive,
  }) async {
    connection =
        HubConnectionBuilder()
            .withUrl("http://10.0.2.2:5155/notifyHub")
            .build();

    connection.on("ReceiveNotification", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        onReceive(arguments[0]);
      }
    });

    await connection.start();

    await connection.invoke("JoinGroup", args: [studentId]);
  }

  Future<void> disconnect() async {
    await connection.stop();
  }
}

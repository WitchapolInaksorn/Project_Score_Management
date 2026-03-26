// import 'package:signalr_core/signalr_core.dart';

// class SignalRService {
//   late HubConnection connection;

//   Future<void> connect(String email) async {
//     connection = HubConnectionBuilder()
//         .withUrl("https://your-api-url/notifyHub") // 🔥 เปลี่ยน URL
//         .withAutomaticReconnect()
//         .build();

//     await connection.start();

//     print("SignalR Connected");

//     // ✅ Join group ด้วย email
//     await connection.invoke("JoinGroupByEmail", args: [email]);

//     print("Joined group: $email");

//     // 🎯 รับ notify คะแนน
//     connection.on("ReceiveStudentScore", (data) {
//       print("📩 Score update: ${data![0]}");
//     });

//     // 🎯 รับ notification
//     connection.on("ReceiveNotification", (data) {
//       print("🔔 Notification: ${data![0]}");
//     });
//   }

//   Future<void> disconnect() async {
//     await connection.stop();
//   }
// }
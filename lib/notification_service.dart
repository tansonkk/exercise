import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handlebackgroudmessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class NotificationAPI {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();

    print('token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handlebackgroudmessage);
  }
}
//Todo
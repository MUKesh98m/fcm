import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:message/notification_Screen.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final androidChannel = const AndroidNotificationChannel(
      "high_importance_channel", "High Importance Notification",
      description:
          "🌟 Introducing Our Kids Learning App - Ignite a World of Knowledge and Fun! 🌟",
      importance: Importance.defaultImportance);
  final localNotofication = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    Get.to(NotificationScreen(
      message: message,
    ));
    FirebaseFirestore.instance.collection('data').add({
      'title': message.notification?.title,
      'body': message.notification?.body,
    });
  }

  Future<void> initNotificataion() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    // FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    print("Firebase Fcm Token===>$fcmToken");
    // initLocalNotification();
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      localNotofication.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  androidChannel.id, androidChannel.name,
                  channelDescription: androidChannel.description,
                  icon: '@drawable/ic_launcher')),
          payload: jsonEncode(message.toMap()));
    });
  }
}

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print(
      'background message********************************************************************************** ');
  print("Title ${message.notification?.title}");
  print("body ${message.notification?.body}");
  print("Data ${message.data}");
}

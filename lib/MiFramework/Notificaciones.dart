 import 'dart:async';
import 'dart:io';

import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/NotifiModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

 FlutterLocalNotificationsPlugin LocalNotifications = FlutterLocalNotificationsPlugin();

 const AndroidNotificationChannel channel = AndroidNotificationChannel(
   'high_importance_channel', // id
   'High Importance Notifications', // title
   'This channel is used for important notifications.', // description
   importance: Importance.max,
   playSound: true,
   enableVibration: true,
 );

 Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
   await Firebase?.initializeApp();
   print('Handling a background message ${message.messageId}');

   RemoteNotification notification = message.notification;
   String Argument = "No_Info";
   if(Platform.isAndroid ){
     AndroidNotification android = message.notification?.android;
     if (notification != null && android != null) {
       var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
         channel.id, channel.name, channel.description,
         icon: 'app_icon',
         importance: Importance.max, priority: Priority.high,  ticker: 'ticker', //sound: RawResourceAndroidNotificationSound('noti')
       );
       var iOSPlatformChannelSpecifics = new IOSNotificationDetails(presentSound: true);
       LocalNotifications.show(
         notification.hashCode,
         notification.title,
         notification.body,
         NotificationDetails(android: androidPlatformChannelSpecifics),
         payload: 'item x',
       );

       Argument = notification.title == 'Notificacion'? 'RestaurantMessage':
       'UsuarioMessage';
       NotificacionLocal.Notificacion = Argument;
       NotificacionLocal.Title = notification.title;
       NotificacionLocal.Body = notification.body;
       // _MsjStreamController.sink.add(Argument);
     }
   } else if(Platform.isIOS ){
     AppleNotification IOS = message.notification?.apple;
     if (notification != null && IOS != null) {
       //Argument = "${notification['data']['TipoNoti']}Message" ?? "No_Info";
       LocalNotifications.show(
         notification.hashCode,
         notification.title,
         notification.body,
         NotificationDetails(
           iOS: IOSNotificationDetails(
             presentSound: true,
           ),
         ),
         payload: 'Custom_Sound',
       );
     }
   }
 }

class TokenNotificaciones{
  //FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String _token;
  Stream<String> _tokenStream;

  void setToken(String token) {
    print('FCM Token: $token');
      _token = token;
    if (_token != null && _token != "")
      RegistrarToken(user.id, _token);
  }

  final _MsjStreamController = StreamController<String>.broadcast();
  Stream<String> get mensaje => _MsjStreamController.stream;

  Future<void> initToken(int id_Usuario) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FirebaseMessaging?.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance.getToken(vapidKey: 'BGpdLRsMJKvFDD9odfPk92uBg-JbQbyoiZdah0XlUyrjG4SDgUsE1iC_kdRgt4Kn0CO7K3RTswPZt61NNuO0XoA').then(setToken);
      _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
      _tokenStream.listen(setToken);

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    LocalNotifications.initialize(initializationSettings);

    RegistrarToken(user.id, _token);
      /*
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    //_firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.requestPermission();

    _firebaseMessaging.getToken().then((token) {
      print("<========== Token =============>");
      print(token);
      RegistrarToken(id_Usuario, token);
      print("<========== Token =============>");
    });
    */

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      String Argument = "No_Info";
      if(Platform.isAndroid ){
        AndroidNotification android = message.notification?.android;
        if (notification != null && android != null) {
          var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
              channel.id, channel.name, channel.description,
              icon: 'app_icon',
              importance: Importance.max, priority: Priority.high,  ticker: 'ticker', //sound: RawResourceAndroidNotificationSound('noti')
          );
          var iOSPlatformChannelSpecifics = new IOSNotificationDetails(presentSound: true);
          LocalNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(android: androidPlatformChannelSpecifics),
            payload: 'item x',
          );

          Argument = notification.title == 'Notificacion'? 'RestaurantMessage':
                     'UsuarioMessage';
          NotificacionLocal.Notificacion = Argument;
          NotificacionLocal.Title = notification.title;
          NotificacionLocal.Body = notification.body;
          _MsjStreamController.sink.add(Argument);
        }
      } else if(Platform.isIOS ){
        AppleNotification IOS = message.notification?.apple;
        if (notification != null && IOS != null) {
          //Argument = "${notification['data']['TipoNoti']}Message" ?? "No_Info";
          LocalNotifications.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                iOS: IOSNotificationDetails(
                  presentSound: true,
                ),
              ),
              payload: 'Custom_Sound',
          );
        }
      }
    });

    /*
    _firebaseMessaging.configure(

      onMessage: (message) {
        print('<===== Mensaje =====>');
        print('<===== ${message} =====>');

        String Argument = "No_Info";

        if(Platform.isAndroid ){
          Argument = "${message['data']['TipoNoti']}Message" ?? "No_Info";
          NotificacionLocal.Notificacion = "${message['data']['TipoNoti']}Message" ?? "No_Info";
          NotificacionLocal.Title = "${message['notification']['title']}" ?? "No_Info";
          NotificacionLocal.Body  = "${message['notification']['body']}" ?? "No_Info";
        } else if(Platform.isIOS ){
          Argument = "${message['TipoNoti']}Message" ?? "No_Info";
          NotificacionLocal.Notificacion = "${message['TipoNoti']}Message" ?? "No_Info";
          //NotificacionLocal.Title = "${message['notification']['title']}" ?? "No_Info";
          //NotificacionLocal.Body  = "${message['notification']['body']}" ?? "No_Info";
          NotificacionLocal.Title = "${message['titleNoti']}" ?? "No_Info";
          NotificacionLocal.Body  = "${message['bodyNoti']}" ?? "No_Info";
        }
        _MsjStreamController.sink.add(Argument);
      },
      onLaunch: (message) {
        print('<===== Launch =====>');
        print('<===== ${message} =====>');

        String Argument = "No_Info";
        if(Platform.isAndroid ){
          Argument = "${message['data']['TipoNoti']}Launch" ?? "No_Info";
          NotificacionLocal.Notificacion = "${message['data']['TipoNoti']}Message" ?? "No_Info";
          NotificacionLocal.Title = "${message['notification']['title']}" ?? "No_Info";
          NotificacionLocal.Body  = "${message['notification']['body']}" ?? "No_Info";          
        } else if(Platform.isIOS ){
          Argument = "${message['TipoNoti']}Launch" ?? "No_Info";
          NotificacionLocal.Notificacion = "${message['TipoNoti']}Message" ?? "No_Info";
          //NotificacionLocal.Title = "${message['title']}" ?? "No_Info";
          //NotificacionLocal.Body  = "${message['body']}" ?? "No_Info";
          NotificacionLocal.Title = "${message['titleNoti']}" ?? "No_Info";
          NotificacionLocal.Body  = "${message['bodyNoti']}" ?? "No_Info";
        }
        _MsjStreamController.sink.add(Argument);
      },
      onResume: (message) {
        print('<===== Resume =====>');
        print('<===== ${message} =====>');

        String Argument = "No_Info";
        if(Platform.isAndroid ){
          Argument = "${message['data']['TipoNoti']}Resume" ?? "No_Info";
          NotificacionLocal.Notificacion = "${message['data']['TipoNoti']}Message" ?? "No_Info";
          NotificacionLocal.Title = "${message['notification']['title']}" ?? "No_Info";
          NotificacionLocal.Body  = "${message['notification']['body']}" ?? "No_Info";
        } else if(Platform.isIOS ){
          Argument = "${message['TipoNoti']}Resume" ?? "No_Info";
          NotificacionLocal.Notificacion = "${message['TipoNoti']}Message" ?? "No_Info";
          //NotificacionLocal.Title = "${message['title']}" ?? "No_Info";
          //NotificacionLocal.Body  = "${message['body']}" ?? "No_Info";
          NotificacionLocal.Title = "${message['titleNoti']}" ?? "No_Info";
          NotificacionLocal.Body  = "${message['bodyNoti']}" ?? "No_Info";
        }
        _MsjStreamController.sink.add(Argument);
      },
    );*/
  }

}

Future<void> RegistrarToken(int id_Usuario, String sToken) async {
  try {
    /*final Response = await post('${sURL}Notificacion/RegistraToken', body: {
      'id_usuario': id_Usuario.toString(),
      'id_Token': sToken
    });*/
    if (sToken != null && sToken != "") {
      //final Response = await post('${sURL}Notificacion/RegistraToken?id_usuario=${id_Usuario}&id_Token=${sToken}');
      final Response = await post(CadenaConexion('Notificacion/RegistraToken?id_usuario=${id_Usuario}&id_Token=${sToken}'));
      if (Response.statusCode == 201 || Response.statusCode == 200) {

      };
    }
  } on Exception catch (ex) {
    print("Error en token: ${ex.toString()}");
  }
}

Future<void> RegistrarTokenRest(int id_Restaurant, String sToken) async {
  try {
    //final Response = await post('${sURL}Notificacion/RegistraTokenRest?id_Restaurant=${id_Restaurant}&id_Token=${sToken}');
    final Response = await post(CadenaConexion('Notificacion/RegistraTokenRest?id_Restaurant=${id_Restaurant}&id_Token=${sToken}'));
    if (Response.statusCode == 201 || Response.statusCode == 200) {

    };
  } on Exception catch (ex) {
    print("Error en token: ${ex.toString()}");
  }
}

class Notificacion{
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  String selectedNotificationPayload;

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> Notificaciones() async {

    _requestPermissions();

    final NotificationAppLaunchDetails notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload = notificationAppLaunchDetails.payload;
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          if (payload != null) {
            debugPrint('notification payload: $payload');
          }
          selectedNotificationPayload = payload;
        });
  }


}

 class ReceivedNotification {
   ReceivedNotification({
     this.id,
     this.title,
     this.body,
     this.payload,
   });

   final int id;
   final String title;
   final String body;
   final String payload;
 }
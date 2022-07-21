import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/services/firebase.service.dart';
import 'package:fuodz/services/taxi_background_order.service.dart';

import 'background_order.service.dart';

class GeneralAppService {
  //

//Hnadle background message
  static Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    FirebaseService().saveNewNotification(message);
    //if is taxi
    if ((await AuthServices.getDriverVehicle()) != null) {
      TaxiBackgroundOrderService().processNotificationForNewOrderAlert(
        message,
        appIsInBackground: true,
      );
    } else {
      BackgroundOrderService().processNotificationForNewOrderAlert(
        message,
        appIsInBackground: true,
      );
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/new_taxi_order.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/requests/order.request.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/services/notification.service.dart';
import 'package:georange/georange.dart';
import 'package:fuodz/translations/home.i18n.dart';
import 'package:singleton/singleton.dart';

class TaxiBackgroundOrderService {
  //
  /// Factory method that reuse same instance automatically
  factory TaxiBackgroundOrderService() =>
      Singleton.lazy(() => TaxiBackgroundOrderService._()).instance;

  /// Private constructor
  TaxiBackgroundOrderService._() {}

  //
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  GeoRange georange = GeoRange();
  User currentUser;
  bool canAcceptNewOrder = true;
  bool showingNewAlertDialog = false;
  StreamController<NewTaxiOrder> showNewOrderStream =
      StreamController.broadcast();
  Timer mOrderNotificationTimer;
  NewTaxiOrder newOrder;
  OrderRequest orderRequest = OrderRequest();

  //NEW ORDER STREAM
  processNotificationForNewOrderAlert(
    RemoteMessage remoteMessage, {
    bool appIsInBackground = false,
  }) async {
    //
    final newAlertData = remoteMessage.data;
    if (newAlertData == null ||
        !newAlertData.containsKey("pickup") ||
        newAlertData["pickup"] == null) {
      return;
    }

    //
    newOrder = NewTaxiOrder.fromJson(newAlertData);
    if (appIsInBackground) {
      showNewOrderNotificationAlert(newAlertData: newAlertData);
    } else {
      showNewOrderStream.add(newOrder);
    }
  }

  //show notification
  showNewOrderNotificationAlert({
    Map<String, dynamic> newAlertData,
    int notifcationId = 10,
  }) async {
    //
    await LocalStorageService.getPrefs();
    //show action notification to driver
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notifcationId,
        ticker: "${AppStrings.appName}",
        channelKey:
            NotificationService.newOrderNotificationChannel().channelKey,
        title: newAlertData["title"] ?? "New Order Alert".i18n,
        backgroundColor: AppColor.primaryColorDark,
        body: newAlertData["body"] ??
            ("Pickup Location".i18n +
                ": " +
                "${newOrder.pickup.address} (${newOrder.pickupDistance.toInt().ceil()}km)"),
        notificationLayout: NotificationLayout.BigText,
        //
        payload: {
          "id": newOrder.id.toString(),
          "notifcationId": notifcationId.toString(),
          "newOrder": jsonEncode(newOrder.toJson()),
        },
      ),
    );

    return;
  }

  //
  //
  //
  //show custom notification
  void showCustomNotification({
    int notifcationId = 10,
    String title = "",
    String body = "",
    Color bgColor,
    NotificationLayout notificationLayout = NotificationLayout.Default,
  }) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notifcationId,
        ticker: "${AppStrings.appName}",
        channelKey: NotificationService.appNotificationChannel().channelKey,
        title: title,
        backgroundColor: bgColor ?? AppColor.primaryColor,
        body: body,
        notificationLayout: notificationLayout ?? NotificationLayout.Default,
        progress: null,
      ),
    );
  }
}

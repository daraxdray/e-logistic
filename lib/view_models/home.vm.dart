import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/new_order.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/models/vehicle.dart';
import 'package:fuodz/requests/auth.request.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/services/background_order.service.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/widgets/bottomsheets/new_order_alert.bottomsheet.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:georange/georange.dart';
import 'package:fuodz/translations/home.i18n.dart';

class HomeViewModel extends MyBaseViewModel {
  //
  HomeViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  // bool isOnline = true;
  int currentIndex = 0;
  User currentUser;
  Vehicle driverVehicle;
  PageController pageViewController = PageController(initialPage: 0);
  StreamSubscription homePageChangeStream;
  StreamSubscription locationReadyStream;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  GeoRange georange = GeoRange();
  StreamSubscription newOrderStream;

  AuthRequest authRequest = AuthRequest();

  @override
  void initialise() async {
    //
    currentUser = await AuthServices.getCurrentUser();
    driverVehicle = await AuthServices.getDriverVehicle();
    //
    AppService().driverIsOnline =
        LocalStorageService.prefs.getBool(AppStrings.onlineOnApp) ?? false;
    notifyListeners();

    //
    locationReadyStream =
        LocationService.locationDataAvailable.stream.listen((event) {
      if (event) {
        print("abut call ==> listenToNewOrders");
        listenToNewOrders();
      }
    });

    //
    homePageChangeStream = AppService().homePageIndex.stream.listen(
      (index) {
        //
        onTabChange(index);
      },
    );
  }

  //
  dispose() {
    super.dispose();
    cancelAllListeners();
  }

  cancelAllListeners() async {
    homePageChangeStream?.cancel();
    newOrderStream?.cancel();
  }

  //
  onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  //
  onTabChange(int index) {
    currentIndex = index;
    pageViewController.animateToPage(
      currentIndex,
      duration: Duration(microseconds: 5),
      curve: Curves.bounceInOut,
    );
    notifyListeners();
  }

  void toggleOnlineStatus() async {
    setBusy(true);
    try {
      //
      final apiResponse = await authRequest.updateProfile(
          isOnline: !AppService().driverIsOnline);
      if (apiResponse.allGood) {
        //
        AppService().driverIsOnline = !AppService().driverIsOnline;
        await LocalStorageService.prefs
            .setBool(AppStrings.onlineOnApp, AppService().driverIsOnline);
        //
        viewContext.showToast(
          msg: "Updated Successfully".i18n,
          bgColor: Colors.green,
          textColor: Colors.white,
        );

        //
        if (AppService().driverIsOnline) {
          listenToNewOrders();
        } else {
          //
          LocationService.clearLocationFromFirebase();
          cancelAllListeners();
        }
      } else {
        viewContext.showToast(
          msg: "${apiResponse.message}",
          bgColor: Colors.red,
        );
      }
    } catch (error) {
      viewContext.showToast(msg: "$error", bgColor: Colors.red);
    }
    setBusy(false);
  }

  //NEW ORDER STREAM
  listenToNewOrders() async {
    //start the background service
    startNewOrderBackgroundService();
    if (AuthServices.driverVehicle == null) {
      newOrderStream =
          BackgroundOrderService().showNewOrderStream.stream.listen(
        (event) {
          showNewOrderAlert(event);
        },
      );
    }
  }

  void showNewOrderAlert(NewOrder newOrder) async {
    //
    final result = await showModalBottomSheet(
      context: AppService().navigatorKey.currentContext,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return NewOrderAlertBottomSheet(newOrder);
      },
    );

    //
    if (result is bool && result) {
      AppService().refreshAssignedOrders.add(true);
    }
  }
}

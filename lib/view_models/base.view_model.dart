import 'package:firebase_chat/firebase_chat.dart';
import 'package:firebase_chat/models/chat_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import 'package:firestore_repository/firestore_repository.dart';

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  @override
  void onCompletedInitialLoad() {
    print("ChromeSafari browser initial load completed");
  }

  @override
  void onClosed() {
    print("ChromeSafari browser closed");
  }
}

class MyBaseViewModel extends BaseViewModel {
  //
  BuildContext viewContext;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final currencySymbol = AppStrings.currencySymbol;
  DeliveryAddress deliveryaddress = DeliveryAddress();
  String firebaseVerificationId;
  ChatEntity chatEntity;

  //

  void initialise() {
    FirestoreRepository();
  }

  newFormKey() {
    formKey = GlobalKey<FormState>();
    notifyListeners();
  }

  //
  void startNewOrderBackgroundService() {
    WidgetsFlutterBinding.ensureInitialized();

    //
    //try sending location to fcm
    if (LocationService.currentLocation != null) {
      print("Resending fcm location");
      LocationService.syncLocationWithFirebase(LocationData.fromMap({
        "latitude": LocationService.currentLocation.latitude,
        "longitude": LocationService.currentLocation.longitude,
      }));
    }
  }

  //
  openWebpageLink(String url) async {
    //
    ChromeSafariBrowser browser = new MyChromeSafariBrowser();
    await browser.open(
      url: Uri.parse(url),
      options: ChromeSafariBrowserClassOptions(
        android: AndroidChromeCustomTabsOptions(
          addDefaultShareMenuItem: false,
          enableUrlBarHiding: true,
          toolbarBackgroundColor: AppColor.primaryColor,
        ),
        ios: IOSSafariOptions(
          barCollapsingEnabled: true,
          preferredBarTintColor: AppColor.primaryColor,
        ),
      ),
    );
  }

  //show toast
  toastSuccessful(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  toastError(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}

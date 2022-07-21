import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/models/order.dart';
import 'package:rxdart/rxdart.dart';
import 'package:singleton/singleton.dart';
import 'package:intl/intl.dart' as intl;
import 'package:i18n_extension/i18n_widget.dart';

class AppService {
  //

  /// Factory method that reuse same instance automatically
  factory AppService() => Singleton.lazy(() => AppService._()).instance;

  /// Private constructor
  AppService._() {}

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  BehaviorSubject<int> homePageIndex = BehaviorSubject<int>();
  BehaviorSubject<bool> refreshAssignedOrders = BehaviorSubject<bool>();
  BehaviorSubject<Order> addToAssignedOrders = BehaviorSubject<Order>();
  bool driverIsOnline = false;
  StreamSubscription actionStream;
  List<int> ignoredOrders = [];
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();


  changeHomePageIndex({int index = 2}) async {
    print("Changed Home Page");
    homePageIndex.add(index);
  }
  static bool isDirectionRTL(BuildContext context) {
    return intl.Bidi.isRtlLanguage(I18n.localeStr);
  }


  //
  void playNotificationSound() {
    try {
      assetsAudioPlayer.stop();
    } catch (error) {
      print("Error stopping audio player");
    }

    //
    assetsAudioPlayer.open(
      Audio("assets/audio/alert.mp3"),
      loopMode: LoopMode.single,
    );
  }
  void stopNotificationSound() {
    try {
      assetsAudioPlayer.stop();
    } catch (error) {
      print("Error stopping audio player");
    }
  }
}

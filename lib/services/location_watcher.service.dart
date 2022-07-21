import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:schedulers/schedulers.dart';
import 'package:fuodz/translations/home.i18n.dart';
import 'package:velocity_x/velocity_x.dart';

class LocationServiceWatcher {
  //
  static bool alertDialogShown = false;
  static int schedulerDuration = 60;
  //
  static void listenToDelayLocationUpdate() async {
    //
    IntervalScheduler scheduler;
    if (!kDebugMode) {
      scheduler = IntervalScheduler(delay: Duration(minutes: 5));
    } else {
      scheduler =
          IntervalScheduler(delay: Duration(seconds: schedulerDuration));
    }
    scheduler.run(
      () async {
        // print("Schedule called ==> #YES");
        //check of last update time is less than 5min ago
        int timeDiff = DateTime.now().millisecondsSinceEpoch;
        timeDiff -= LocationService.lastUpdated;
        //
        if (timeDiff > 300000 && AppService().driverIsOnline) {
          //show alert dialog if driver is yet to be shown a dialog
          await showModalBottomSheet(
            context: AppService().navigatorKey.currentContext,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return VStack(
                [
                  UiSpacer.slideIndicator(),
                  UiSpacer.verticalSpace(),
                  Image.asset(AppImages.noLocation),
                  "Location Error".i18n.text.xl2.semiBold.makeCentered(),
                  "Delay in driver location update".i18n.text.makeCentered(),
                ],
                crossAlignment: CrossAxisAlignment.center,
              )
                  .p20()
                  .scrollVertical()
                  .hThreeForth(context)
                  .box
                  .color(context.backgroundColor)
                  .topRounded()
                  .make();
            },
          );
        }
        //increase the next scheduler time/seconds
        schedulerDuration += 10;
        listenToDelayLocationUpdate();
      },
    );
  }
}

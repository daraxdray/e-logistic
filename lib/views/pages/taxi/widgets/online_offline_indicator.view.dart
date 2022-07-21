import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/view_models/taxi/taxi.vm.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/taxi.i18n.dart';
import 'package:rolling_switch/rolling_switch.dart';

class OnlineOfflineIndicatorView extends StatelessWidget {
  const OnlineOfflineIndicatorView(this.vm, {Key key}) : super(key: key);
  final TaxiViewModel vm;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: SafeArea(
        child: VStack(
          [
            //

            //
            !vm.busy(vm.appService.driverIsOnline)
                ? RollingSwitch.icon(
                    initialState: vm.appService.driverIsOnline,
                    onChanged: (bool state) {
                      print('turned ${(state) ? 'on' : 'off'}');
                      vm.newTaxiBookingService.toggleVisibility(state);
                    },
                    rollingInfoRight: RollingIconInfo(
                      icon: FlutterIcons.location_on_mdi,
                      text: Text(
                        'Online'.i18n,
                        style: context.textTheme.bodyText1.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: AppColor.primaryColor,
                      iconColor: AppColor.primaryColor,
                    ),
                    rollingInfoLeft: RollingIconInfo(
                      icon: FlutterIcons.location_off_mdi,
                      backgroundColor: Colors.grey,
                      text: Text(
                        'Offline'.i18n,
                        style: context.textTheme.bodyText1.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ).py16().centered()
                : BusyIndicator().py16().centered(),
          ],
        ),
      ),
    );
  }
}

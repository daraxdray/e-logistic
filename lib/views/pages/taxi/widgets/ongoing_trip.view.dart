import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/taxi/taxi.vm.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/call.button.dart';
import 'package:fuodz/widgets/buttons/route.button.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:measure_size/measure_size.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/taxi.i18n.dart';
import 'package:supercharged/supercharged.dart';

class OnGoingTripView extends StatelessWidget {
  const OnGoingTripView(this.vm, {Key key}) : super(key: key);

  final TaxiViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Visibility(
        visible: vm.onGoingOrderTrip != null,
        child: MeasureSize(
          onChange: (size) {
            vm.updateGoogleMapPadding(150);
          },
          child: SlidingUpPanel(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            minHeight: 150,
            panel: VStack(
              [
                //
                UiSpacer.slideIndicator(),
                //
                HStack(
                  [
                    //
                    CustomImage(
                      imageUrl: vm.onGoingOrderTrip?.user?.photo,
                      width: 60,
                      height: 60,
                    ).box.roundedFull.clip(Clip.antiAlias).make(),
                    VStack(
                      [
                        //
                        "${vm.onGoingOrderTrip?.user?.name}"
                            .text
                            .xl2
                            .medium
                            .make(),
                        VxRating(
                          maxRating: 5,
                          selectionColor: AppColor.ratingColor,
                          value: vm.onGoingOrderTrip?.user?.rating,
                          onRatingUpdate: null,
                        ),
                      ],
                    ).px12().expand(),
                    "${AppStrings.currencySymbol}"
                        .richText
                        .xl3
                        .withTextSpanChildren(
                      [
                        "${vm.onGoingOrderTrip?.total}"
                            .textSpan
                            .light
                            .size(Vx.dp20)
                            .make(),
                      ],
                    ).make(),
                  ],
                ),
                //
                HStack(
                  [
                    //
                    CustomTextFormField(
                      hintText: "Message".i18n +
                          " ${vm.onGoingOrderTrip?.user?.name}",
                      isReadOnly: true,
                      onTap: vm.chatCustomer,
                    ).expand(),
                    //
                    UiSpacer.horizontalSpace(),
                    //call
                    CallButton(
                      null,
                      phone: vm.onGoingOrderTrip?.user?.phone,
                      size: 32,
                    ),
                  ],
                ).py12(),
                //
                UiSpacer.divider(),
                //pickup address
                UiSpacer.verticalSpace(),
                HStack(
                  [
                    //
                    VStack(
                      [
                        "Pickup Address".i18n.text.hairLine.lg.make(),
                        "${vm.onGoingOrderTrip?.taxiOrder?.pickupAddress}"
                            .text
                            .xl
                            .semiBold
                            .make(),
                      ],
                    ).expand(),
                    UiSpacer.horizontalSpace(),
                    RouteButton(
                      null,
                      lat: vm.onGoingOrderTrip?.taxiOrder?.pickupLatitude
                          ?.toDouble(),
                      lng: vm.onGoingOrderTrip?.taxiOrder?.pickupLongitude
                          ?.toDouble(),
                    ),
                  ],
                ),
                UiSpacer.verticalSpace(),
                //dropoff address
                HStack(
                  [
                    //
                    VStack(
                      [
                        "Dropoff Address".i18n.text.hairLine.lg.make(),
                        "${vm.onGoingOrderTrip?.taxiOrder?.dropoffAddress}"
                            .text
                            .xl
                            .semiBold
                            .make(),
                      ],
                    ).expand(),
                    UiSpacer.horizontalSpace(),
                    RouteButton(
                      null,
                      lat: vm.onGoingOrderTrip?.taxiOrder?.dropoffLatitude
                          ?.toDouble(),
                      lng: vm.onGoingOrderTrip?.taxiOrder?.dropoffLongitude
                          ?.toDouble(),
                    ),
                  ],
                ),
                UiSpacer.verticalSpace(),
                //
                UiSpacer.divider(),
                //swipe to accept
                VStack(
                  [
                    new SwipingButton(
                      key: vm.formKey,
                      height: 50,
                      backgroundColor: AppColor.accentColor.withOpacity(0.50),
                      swipeButtonColor: AppColor.primaryColorDark,
                      swipePercentageNeeded: 0.80,
                      text: "${vm.onGoingTaxiBookingService.getNewStateStatus}"
                          .i18n,
                      onSwipeCallback:
                          vm.onGoingTaxiBookingService.processOrderStatusUpdate,
                    ).wFull(context).box.make().h(vm.isBusy ? 0 : 50),
                    vm.isBusy
                        ? BusyIndicator().centered().p20()
                        : UiSpacer.emptySpace(),
                  ],
                ).py12(),
                SafeArea(
                  top: false,
                  child: "Swipe to notify rider".i18n.text.makeCentered().py4(),
                ),
              ],
            ).p20(),
          ),
        ),
      ),
    );
  }
}

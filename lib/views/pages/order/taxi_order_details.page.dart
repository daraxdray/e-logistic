import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/order_details.vm.dart';
import 'package:fuodz/views/pages/order/widgets/order_payment_info.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/cards/order_summary.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/order_details.i18n.dart';
import 'package:ticketview/ticketview.dart';

class TaxiOrderDetailPage extends StatelessWidget {
  const TaxiOrderDetailPage({this.order, Key key}) : super(key: key);

  //
  final Order order;

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      body: ViewModelBuilder<OrderDetailsViewModel>.reactive(
        viewModelBuilder: () => OrderDetailsViewModel(context, order),
        onModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return BasePage(
            title: "Trip Details".i18n,
            elevation: 0,
            showAppBar: true,
            showLeadingAction: true,
            onBackPressed: vm.onBackPressed,
            isLoading: vm.isBusy,
            body: vm.isBusy
                ? BusyIndicator().centered()
                : TicketView(
                    triangleAxis: Axis.vertical,
                    contentPadding: EdgeInsets.zero,
                    drawTriangle: true,
                    trianglePos: 0.60,
                    child: VStack(
                      [
                        //code & total amount
                        HStack(
                          [
                            //
                            VStack(
                              [
                                "Code".i18n.text.gray500.medium.sm.make(),
                                "#${vm.order.code}".text.medium.xl.make(),
                              ],
                            ).expand(),
                            //total amount
                            AppStrings.currencySymbol.text.medium.lg
                                .make()
                                .px4(),
                            (vm.order.total ?? 0.00)
                                .numCurrency
                                .text
                                .medium
                                .xl2
                                .make(),
                          ],
                        ).pOnly(bottom: Vx.dp20),

                        //order delivery/pickup location
                        VStack(
                          [
                            "Pickup Address".i18n.text.gray500.medium.sm.make(),
                            vm.order.taxiOrder.pickupAddress.text.xl.medium
                                .make(),
                          ],
                        ),
                        UiSpacer.verticalSpace(),
                        VStack(
                          [
                            "Dropoff Address"
                                .i18n
                                .text
                                .gray500
                                .medium
                                .sm
                                .make(),
                            vm.order.taxiOrder.dropoffAddress.text.xl.medium
                                .make(),
                          ],
                        ),
                        UiSpacer.verticalSpace(),

                        //status
                        "Status".i18n.text.gray500.medium.sm.make(),
                        vm.order.taxiStatus
                            .allWordsCapitilize()
                            .text
                            .color(AppColor.getStausColor(vm.order.status))
                            .medium
                            .xl
                            .make()
                            .pOnly(bottom: Vx.dp20),

                        //payment status
                        OrderPaymentInfoView(vm),

                        //customer
                        VStack(
                          [
                            "Customer".i18n.text.gray500.medium.sm.make(),
                            vm.order.user.name.text.medium.xl
                                .make()
                                .pOnly(bottom: Vx.dp20),
                          ],
                        ),

                        //order summary
                        OrderSummary(
                          subTotal: vm.order.subTotal,
                          discount: vm.order.discount ?? 0,
                          driverTip: vm.order.tip,
                          total: vm.order.total,
                        ).pOnly(top: Vx.dp20, bottom: Vx.dp56),
                      ],
                    ).p20(),
                  )
                    .p20()
                    .scrollVertical()
                    .box
                    .color(AppColor.primaryColor)
                    .make(),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/payment_account.dart';
import 'package:fuodz/services/validator.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/earning.vm.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/buttons/custom_text_button.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/profile.i18n.dart';

class EarningBottomSheet extends StatelessWidget {
  const EarningBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EarningViewModel>.reactive(
      viewModelBuilder: () => EarningViewModel(context),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return VStack(
          [
            "Earning".i18n.text.medium.xl2.makeCentered(),
            vm.isBusy
                ? BusyIndicator().centered().p20().expand()
                : VStack(
                    [
                      //amount
                      HStack(
                        [
                          //currency
                          vm.currency.symbol.text.medium.xl.make().px4(),
                          //earning
                          vm.earning.amount.numCurrency.text.semiBold.xl3
                              .make(),
                        ],
                        crossAlignment: CrossAxisAlignment.center,
                        alignment: MainAxisAlignment.center,
                      ).py12(),
                      //updated at
                      vm.earning.formattedUpdatedDate.text.medium.lg
                          .makeCentered(),

                      //request payout
                      Visibility(
                        visible: !vm.showPayout,
                        child: CustomButton(
                          title: "Request Payout".i18n,
                          onPressed: vm.requestEarningPayout,
                        ).py20(),
                      ),

                      //payout form
                      Visibility(
                        visible: vm.showPayout,
                        child: Form(
                          key: vm.formKey,
                          child: vm.busy(vm.paymentAccounts)
                              ? BusyIndicator().centered().py20()
                              : VStack(
                                  [
                                    //
                                    Divider(thickness: 2).py12(),
                                    "Request Payout".i18n.text.medium.xl.make(),
                                    UiSpacer.verticalSpace(),
                                    //
                                    "Payment Account"
                                        .i18n
                                        .text
                                        .base
                                        .light
                                        .make(),
                                    DropdownButtonFormField<PaymentAccount>(
                                      decoration: InputDecoration.collapsed(
                                          hintText: ""),
                                      value: vm.selectedPaymentAccount,
                                      onChanged: (value) {
                                        vm.selectedPaymentAccount = value;
                                        vm.notifyListeners();
                                      },
                                      items: vm.paymentAccounts.map(
                                        (e) {
                                          return DropdownMenuItem(
                                              value: e,
                                              child:
                                                  Text("${e.name}(${e.number})")
                                              // .text
                                              // .make(),
                                              );
                                        },
                                      ).toList(),
                                    )
                                        .p12()
                                        .box
                                        .border(color: AppColor.accentColor)
                                        .roundedSM
                                        .make()
                                        .py4(),
                                    //
                                    UiSpacer.verticalSpace(space: 10),
                                    CustomTextFormField(
                                      labelText: "Amount".i18n,
                                      textEditingController: vm.amountTEC,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                      validator: (value) =>
                                          FormValidator.validateCustom(
                                        value,
                                        rules: "required||numeric||lte:${vm.earning.amount}",
                                      ),
                                    ).py12(),
                                    CustomButton(
                                      title: "Request Payout".i18n,
                                      loading:
                                          vm.busy(vm.selectedPaymentAccount),
                                      onPressed: vm.processPayoutRequest,
                                    ).centered().py12(),
                                    //
                                    CustomTextButton(
                                      title: "Close".i18n,
                                      onPressed: () {
                                        vm.showPayout = false;
                                        vm.notifyListeners();
                                      },
                                    ).centered(),
                                  ],
                                ).scrollVertical(),
                        ),
                      ),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                    alignment: MainAxisAlignment.center,
                  ),
          ],
        )
            .p20()
            .h(context.percentHeight * (vm.showPayout ? 80 : 34))
            .box
            .color(context.backgroundColor)
            .topRounded()
            .make();
      },
    );
  }
}

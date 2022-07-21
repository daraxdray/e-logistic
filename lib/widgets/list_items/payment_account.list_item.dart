import 'package:flutter/material.dart';
import 'package:fuodz/models/payment_account.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/payment_accounts.i18n.dart';

class PaymentAccountListItem extends StatelessWidget {
  const PaymentAccountListItem(this.paymentAccount, {Key key, this.onPressed})
      : super(key: key);

  final PaymentAccount paymentAccount;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Row(
          children: [
            //name
            VStack(
              [
                "Account Name".i18n.text.sm.make(),
                "${paymentAccount.name}".text.xl.medium.make(),
              ],
            ),
            UiSpacer.expandedSpace(),
            //
            VStack(
              [
                "Account Number".i18n.text.sm.make(),
                "${paymentAccount.number}".text.xl.medium.make(),
              ],
            ),
          ],
        ),

        //

        Visibility(
          visible: paymentAccount.instructions != null &&
              paymentAccount.instructions.isNotEmpty,
          child: VStack(
            [
              "Instructions".i18n.text.medium.make(),
              "${paymentAccount.instructions}".text.sm.hairLine.make(),
            ],
          ).pOnly(top: Vx.dp12),
        ),
      ],
    )
        .p12()
        .box
        .color(context.backgroundColor)
        .outerShadow
        .rounded
        .margin(EdgeInsets.symmetric(horizontal: Vx.dp4))
        .make()
        .opacity(value: paymentAccount.isActive ? 1.0 : 0.6).onInkTap(onPressed);
  }
}

import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/widgets/states/empty.state.dart';
import 'package:fuodz/translations/payment_accounts.i18n.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptyPaymentAccount extends StatelessWidget {
  const EmptyPaymentAccount({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      imageUrl: AppImages.paymentAccount,
      title: "Payment Account Not Found".i18n,
      description: "Please create a new payment account. This can be use to receive earning from the platform".i18n,
    ).p20().centered();
  }
}
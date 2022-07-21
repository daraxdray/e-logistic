import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/models/payment_account.dart';
import 'package:fuodz/requests/payment_account.request.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/payment_accounts.i18n.dart';

class NewPaymentAccountViewModel extends MyBaseViewModel {
  //
  NewPaymentAccountViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  PaymentAccountRequest paymentAccountRequest = PaymentAccountRequest();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController numberTEC = TextEditingController();
  TextEditingController instructionsTEC = TextEditingController();
  bool isActive = true;

  //
  processSave() async {
    if (formKey.currentState.validate()) {
      //
      setBusy(true);
      //
      final apiResponse = await paymentAccountRequest.newPaymentAccount(
        {
          "name": nameTEC.text,
          "number": numberTEC.text,
          "instructions": instructionsTEC.text,
          "is_active": isActive ? "1" : "0",
        },
      );

      //
      CoolAlert.show(
        context: viewContext,
        type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
        title: "New Payment Account".i18n,
        text:
            apiResponse.allGood ? "Successful".i18n : "${apiResponse.message}",
        onConfirmBtnTap: apiResponse.allGood
            ? () {
                //cool
                final newPaymentAccount = PaymentAccount.fromJson(
                  apiResponse.body["data"],
                );
                //
                viewContext.pop();
                viewContext.pop(newPaymentAccount);
              }
            : null,
      );
      setBusy(false);
    }
  }
}

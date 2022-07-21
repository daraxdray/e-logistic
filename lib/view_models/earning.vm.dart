import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fuodz/models/currency.dart';
import 'package:fuodz/models/earning.dart';
import 'package:fuodz/models/payment_account.dart';
import 'package:fuodz/requests/earning.request.dart';
import 'package:fuodz/requests/payment_account.request.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/translations/profile.i18n.dart';
import 'package:velocity_x/velocity_x.dart';

class EarningViewModel extends MyBaseViewModel {
  //
  EarningRequest earningRequest = EarningRequest();
  PaymentAccountRequest paymentAccountRequest = PaymentAccountRequest();
  Currency currency;
  Earning earning;
  bool showPayout = false;
  List<PaymentAccount> paymentAccounts = [];
  PaymentAccount selectedPaymentAccount;
  TextEditingController amountTEC = TextEditingController();

  EarningViewModel(BuildContext context) {
    this.viewContext = context;
  }

  void initialise() async {
    //
    fetchEarning();
  }

  fetchEarning() async {
    setBusy(true);
    try {
      final results = await earningRequest.getEarning();
      currency = results[0];
      earning = results[1];
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  //
  void requestEarningPayout() async {
    showPayout = true;
    notifyListeners();
    //
    if (paymentAccounts != null && paymentAccounts.isNotEmpty) {
      return;
    }
    //
    setBusyForObject(paymentAccounts, true);
    try {
      paymentAccounts = (await paymentAccountRequest.paymentAccounts(page: 0))
          .filter((e) => e.isActive).toList();
    } catch (error) {
      print("paymentAccounts error ==> $error");
    }
    setBusyForObject(paymentAccounts, false);
  }

  processPayoutRequest() async {
    //
    if (selectedPaymentAccount == null) {
      toastError("Please select payment account".i18n);
      //
    } else if (formKey.currentState.validate()) {
      setBusyForObject(selectedPaymentAccount, true);
      //
      final apiResponse = await paymentAccountRequest.requestPayout(
        {
          "amount": amountTEC.text,
          "payment_account_id": selectedPaymentAccount.id,
        },
      );
      //
      CoolAlert.show(
        context: viewContext,
        type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
        title: "Request Payout".i18n,
        text:
            apiResponse.allGood ? "Successful".i18n : "${apiResponse.message}",
        onConfirmBtnTap: apiResponse.allGood
            ? () {
                viewContext.pop();
                viewContext.pop();
              }
            : null,
      );

      setBusyForObject(selectedPaymentAccount, false);
    }
  }
}

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/models/wallet.dart';
import 'package:fuodz/models/wallet_transaction.dart';
import 'package:fuodz/requests/wallet.request.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/widgets/bottomsheets/wallet_amount_entry.bottomsheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/wallet.i18n.dart';

class WalletViewModel extends MyBaseViewModel {
  //
  WalletViewModel(BuildContext context, {this.order}) {
    this.viewContext = context;
  }

  //
  WalletRequest walletRequest = WalletRequest();
  RefreshController refreshController = RefreshController();
  TextEditingController transferAmountTEC = TextEditingController();
  Wallet wallet;
  Order order;
  List<WalletTransaction> walletTransactions = [];
  int queryPage = 1;

  //
  initialise() async {
    await getWalletBalance();
    await getWalletTransactions();
  }

  //
  getWalletBalance() async {
    setBusy(true);
    try {
      wallet = await walletRequest.walletBalance();
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  getWalletTransactions({bool initialLoading = true}) async {
    //
    if (initialLoading) {
      setBusyForObject(walletTransactions, true);
      refreshController.refreshCompleted();
      queryPage = 1;
    } else {
      queryPage = queryPage + 1;
    }

    try {
      //
      final mWalletTransactions = await walletRequest.walletTransactions(
        page: queryPage,
      );
      //
      if (initialLoading) {
        walletTransactions = mWalletTransactions;
      } else {
        walletTransactions.addAll(mWalletTransactions);
        refreshController.loadComplete();
      }
      clearErrors();
    } catch (error) {
      print("Wallet transactions error ==> $error");
      setErrorForObject(walletTransactions, error);
    }
    setBusyForObject(walletTransactions, false);
  }

  //
  showAmountEntry() {
    showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      builder: (context) {
        return WalletAmountEntryBottomSheet(
          onSubmit: (String amount) {
            viewContext.pop();
            initiateWalletTopUp(amount);
          },
        );
      },
    );
  }

  //
  initiateWalletTopUp(String amount) async {
    setBusy(true);

    try {
      
      final link = await walletRequest.walletTopup(amount);
      openWebpageLink(link);
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  // wallet balance transfer
  initiateWalletTransfer() async {
    if (formKey.currentState.validate()) {
      setBusyForObject(transferAmountTEC, true);
      try {
        final apiResponse = await walletRequest.transferBalanceRequest(
          amount: transferAmountTEC.text,
          userId: order.userId,
        );

        //show dialog in repsent to the response
        CoolAlert.show(
          context: viewContext,
          type:
              apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
          title: "Topup Customer Wallet".i18n,
          text: apiResponse.message,
          onConfirmBtnTap: apiResponse.allGood
              ? () {
                  viewContext.pop();
                  viewContext.pop();
                }
              : null,
        );
      } catch (error) {
        print("Transfer balance error ===> $error");
        CoolAlert.show(
          context: viewContext,
          type: CoolAlertType.error,
          title: "Topup Customer Wallet".i18n,
          text: "$error",
        );
      }
      setBusyForObject(transferAmountTEC, false);
    }
  }
}

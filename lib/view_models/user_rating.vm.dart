import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/requests/order.request.dart';
import 'package:fuodz/requests/taxi.request.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/taxi.i18n.dart';

class UserRatingViewModel extends MyBaseViewModel {
  //
  OrderRequest orderRequest = OrderRequest();
  Order order;
  int rating = 1;
  Function onsubmitted;
  TextEditingController reviewTEC = TextEditingController();

  //
  UserRatingViewModel(
    BuildContext context,
    this.order,
    this.onsubmitted,
  ) {
    this.viewContext = context;
  }

  void updateRating(String value) {
    rating = double.parse(value).ceil();
  }

  submitRating() async {
    setBusy(true);
    //
    final apiResponse = await TaxiRequest().rateUser(
      order.id,
      order.userId,
      rating.toDouble(),
      reviewTEC.text,
    );
    setBusy(false);

    //
    CoolAlert.show(
      context: viewContext,
      type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
      title: "Rider Rating".i18n,
      text: apiResponse.message,
      onConfirmBtnTap: apiResponse.allGood
          ? () {
              //
              viewContext.pop();
              onsubmitted();
            }
          : null,
    );
  }
}

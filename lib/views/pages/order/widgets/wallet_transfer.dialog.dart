import 'package:flutter/material.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/services/validator.service.dart';
import 'package:fuodz/translations/wallet.i18n.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/wallet.vm.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class WalletTransferDialog extends StatelessWidget {
  const WalletTransferDialog(this.order, {Key key}) : super(key: key);

  final Order order;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WalletViewModel>.reactive(
      viewModelBuilder: () => WalletViewModel(context, order: order),
      builder: (context, vm, child) {
        return Form(
          key: vm.formKey,
          child: VStack(
            [
              "Topup Customer Wallet".i18n.text.semiBold.xl.make(),
              "Please enter amount to transfer from your account to customer wallet"
                  .i18n
                  .text
                  .medium
                  .sm
                  .make()
                  .py4(),
              UiSpacer.verticalSpace(),
              CustomTextFormField(
                labelText: "Amount".i18n,
                textEditingController: vm.transferAmountTEC,
                keyboardType: TextInputType.number,
                validator: (value) => FormValidator.validateCustom(
                  value,
                  name: "Amount".i18n,
                ),
              ),
              UiSpacer.verticalSpace(),
              CustomButton(
                title: "Transfer".i18n,
                loading: vm.busy(vm.transferAmountTEC),
                onPressed: vm.initiateWalletTransfer,
              ).wFull(context),
              CustomButton(
                title: "Cancel".i18n,
                color: Colors.grey,
                loading: vm.busy(vm.transferAmountTEC),
                onPressed: () {
                  context.pop();
                },
              ).wFull(context).py8(),
            ],
          ).p20().scrollVertical().pOnly(bottom: context.mq.viewInsets.bottom),
        );
      },
    );
  }
}

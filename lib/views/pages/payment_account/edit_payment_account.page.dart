import 'package:flutter/material.dart';
import 'package:fuodz/models/payment_account.dart';
import 'package:fuodz/services/validator.service.dart';
import 'package:fuodz/view_models/edit_payment_account.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/translations/payment_accounts.i18n.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class EditPaymentAccountPage extends StatelessWidget {
  const EditPaymentAccountPage(this.paymentAccount, {Key key})
      : super(key: key);

  final PaymentAccount paymentAccount;

  @override
  Widget build(BuildContext context) {
    //
    return BasePage(
      title: "Edit Payment Account".i18n,
      showLeadingAction: true,
      showAppBar: true,
      body: ViewModelBuilder<EditPaymentAccountViewModel>.reactive(
        viewModelBuilder: () =>
            EditPaymentAccountViewModel(context, paymentAccount),
        onModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return VStack(
            [
              //
              Form(
                key: vm.formKey,
                child: VStack(
                  [
                    //
                    CustomTextFormField(
                      labelText: "Account Name".i18n,
                      textEditingController: vm.nameTEC,
                      validator: FormValidator.validateName,
                    ).py12(),
                    CustomTextFormField(
                      labelText: "Account Number".i18n,
                      keyboardType: TextInputType.number,
                      textEditingController: vm.numberTEC,
                      validator: (value) => FormValidator.validateCustom(value),
                    ).py12(),
                    CustomTextFormField(
                      labelText: "Instructions".i18n,
                      keyboardType: TextInputType.multiline,
                      textEditingController: vm.instructionsTEC,
                    ).py12(),
                    //
                    HStack(
                      [
                        Checkbox(
                          value: vm.isActive,
                          onChanged: (value) {
                            vm.isActive = value;
                            vm.notifyListeners();
                          },
                        ),
                        "Active".i18n.text.make().expand(),
                      ],
                    ).py12(),

                    CustomButton(
                      title: "Save".i18n,
                      loading: vm.isBusy,
                      onPressed: vm.processSave,
                    ).centered().py12(),
                  ],
                  crossAlignment: CrossAxisAlignment.end,
                ),
              )
            ],
          ).p20().scrollVertical();
        },
      ),
    );
  }
}

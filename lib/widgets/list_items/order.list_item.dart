import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/order.i18n.dart';

class OrderListItem extends StatelessWidget {
  const OrderListItem({
    this.order,
    this.onPayPressed,
    this.orderPressed,
    Key key,
  }) : super(key: key);

  final Order order;
  final Function onPayPressed;
  final Function orderPressed;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        HStack(
          [
            //vendor image
            CustomImage(
              imageUrl: order.vendor.featureImage,
              width: context.percentWidth * 20,
              boxFit: BoxFit.cover,
              height: context.percentHeight * 12,
            ),

            //
            VStack(
              [
                //
                "#${order.code}".text.xl.medium.make(),
                //amount and total products
                HStack(
                  [
                    ( order.isPackageDelivery ? order.packageType.name :"%s Product(s)"
                        .i18n
                        .fill([order.orderProducts.length]))
                        .text
                        .medium
                        .make()
                        .expand(),
                    "${AppStrings.currencySymbol} ${order.total.numCurrency}"
                        .text
                        .xl
                        .semiBold
                        .make(),
                  ],
                ),
                //time & status
                HStack(
                  [
                    //time
                    order.formattedDate.text.sm.make().expand(),
                    "${order.status
                        .allWordsCapitilize() ?? ''}".i18n
                        .text
                        .lg
                        .color(
                          AppColor.getStausColor(order.status),
                        )
                        .medium
                        .make(),
                  ],
                ),
              ],
            ).p12().expand(),
          ],
        ),
      ],
    )
        .onInkTap(orderPressed)
        .card
        .elevation(1)
        .clip(Clip.antiAlias)
        .roundedSM
        .make();
  }
}

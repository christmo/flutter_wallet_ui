import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/data/data.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/transfer.dart';
import 'package:flutter_wallet_ui_challenge/src/utils/screen_size.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/add_button.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/payment_card.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/products.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/user_card.dart';

import 'overview_page.dart';

Widget inferior(Size _media, BuildContext context, int userId) {
  return Container(
    color: Colors.grey.shade50,
    width: _media.width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 25.0, right: 10, bottom: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Enviar Dinero",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 25),
          height:
              screenAwareSize(_media.longestSide <= 775 ? 110 : 80, context),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: getUsersCard().length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                      padding: EdgeInsets.only(right: 10), child: AddButton());
                }

                return Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Transfer(getUsersCard()[index - 1], userId))),
                    child: UserCardWidget(
                      user: getUsersCard()[index - 1],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 25.0, bottom: 15, right: 10, top: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Productos",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Recivido",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Enviado",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
              },
              child: ProductsListWidget(userId),
              /*child: ListView.separated(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 85.0),
                    child: Divider(),
                  );
                },
                padding: EdgeInsets.zero,
                itemCount: getPaymentsCard().length,
                itemBuilder: (BuildContext context, int index) {
                  return PaymentCardWidget(
                    payment: getPaymentsCard()[index],
                  );
                },
              ),*/
            ),
          ],
        ),
      ],
    ),
  );
}

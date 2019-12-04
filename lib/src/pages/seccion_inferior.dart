import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/data/data.dart';
import 'package:flutter_wallet_ui_challenge/src/models/customer.dart';
import 'package:flutter_wallet_ui_challenge/src/models/user_model.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/transfer.dart';
import 'package:flutter_wallet_ui_challenge/src/utils/screen_size.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/add_button.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/payment_card.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/products.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/user_card.dart';
import 'package:toast/toast.dart';

import 'overview_page.dart';

Widget inferior(
    Size _media, BuildContext context, int userId, Customer customer) {
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
              child: loadTransferFriends(customer)),
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
                "Recibido",
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
            ),
          ],
        ),
      ],
    ),
  );
}

Widget loadTransferFriends(Customer customer) {
  List<UserModel> friends = getUsersCard();
  //friends =
  //    friends.where((friend) => friend.code != int.parse(customer.id)).toList();
  return ListView.builder(
    physics: BouncingScrollPhysics(),
    scrollDirection: Axis.horizontal,
    itemCount: friends.length + 1,
    itemBuilder: (BuildContext context, int index) {
      if (index == 0) {
        return Padding(padding: EdgeInsets.only(right: 10), child: AddButton());
      }
      return Padding(
        padding: EdgeInsets.only(right: 20),
        child: GestureDetector(
          onTap: () {
            openTransfer(context, index, customer);
          },
          child: UserCardWidget(
            user: friends[index - 1],
          ),
        ),
      );
    },
  );
}

void openTransfer(BuildContext context, int index, Customer customer) async {
  int userId = int.parse(customer.id);
  String result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              Transfer(getUsersCard()[index - 1], userId, customer)));
  if (result != null && result.length > 0) {
    Toast.show("Transferencia Enviada Exitosamente", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
  }
}

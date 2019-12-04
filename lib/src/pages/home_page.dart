import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/data/data.dart';
import 'package:flutter_wallet_ui_challenge/src/models/customer.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/overview_page.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/seccion_inferior.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/seccion_superior.dart';
import 'package:flutter_wallet_ui_challenge/src/utils/screen_size.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/add_button.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/credit_card.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/payment_card.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/user_card.dart';

class HomePage extends StatelessWidget {

  final Customer customer;

  HomePage(this.customer);

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    int userId = int.parse(customer.id);
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          superior(_media, context, userId, customer),
          inferior(_media, context, userId, customer)
        ],
      ),
    );
  }
}

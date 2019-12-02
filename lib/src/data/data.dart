import 'dart:async';
import 'dart:convert' as convert;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/models/account.dart';
import 'package:flutter_wallet_ui_challenge/src/models/credit_card_model.dart';
import 'package:flutter_wallet_ui_challenge/src/models/payment_model.dart';
import 'package:flutter_wallet_ui_challenge/src/models/user_model.dart';
import 'package:http/http.dart' as http;
import '../models/card8a.dart';

List<CreditCardModel> getCreditCards() {
  List<CreditCardModel> creditCards = [];
  creditCards.add(CreditCardModel(
      "4616900007729988",
      "https://resources.mynewsdesk.com/image/upload/ojf8ed4taaxccncp6pcp.png",
      "06/23",
      "192"));
  creditCards.add(CreditCardModel(
      "3015788947523652",
      "https://resources.mynewsdesk.com/image/upload/ojf8ed4taaxccncp6pcp.png",
      "04/25",
      "217"));
  return creditCards;
}

List<UserModel> getUsersCard() {
  List<UserModel> userCards = [
    UserModel("Adrian", "assets/images/users/adrian.jpeg", 5),
    UserModel("Karla", "assets/images/users/karla.jpeg", 1),
    UserModel("Xavi", "assets/images/users/xavi.jpeg", 2),
  ];

  return userCards;
}

List<PaymentModel> getPaymentsCard() {
  List<PaymentModel> paymentCards = [
    PaymentModel(Icons.receipt, Color(0xFFffd60f), "Florenti Restaurant",
        "07-23", "20.04", 251.00, -1),
    PaymentModel(Icons.monetization_on, Color(0xFFff415f), "Transfer To Anna",
        "07-23", "14.01", 64.00, -1),
    PaymentModel(Icons.location_city, Color(0xFF50f3e2), "Loan To Sanchez",
        "07-23", "10.04", 1151.00, -1),
    PaymentModel(Icons.train, Colors.green, "Train ticket to Turkey", "07-23",
        "09.04", 37.00, -1),
  ];

  return paymentCards;
}

Future<List<Card8A>> queryCards(int user) async {
  print("Getting cards from User: " + user.toString());
  try {
    http.Response response = await http.get(
        'https://kvillacreses-eval-prod.apigee.net/tarjetas/credit_cards?customer_id=' +
            user.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> body = convert.jsonDecode(response.body);
      int code = body['response']['code'];
      if (code == 0) {
        List<dynamic> res = body['response']['message'];
        List<Card8A> cards =
        res.map((dynamic item) => Card8A.fromJson(item)).toList();
        return Future<List<Card8A>>.value(cards);
      } else {
        print("Error " +
            body['response']['message'] +
            " " +
            body['response']['error']);
      }
    }
  } on Exception catch (e){
    print("Error consultando tarjetas cliente " + user.toString());
  }
  return Future.value(new List());
}

Future<List<Account>> getAccount(int userId) async {
  List<Account> accounts = new List();
  var client = new http.Client();
  http.Response response = await client.get(
      'https://kvillacreses-eval-prod.apigee.net/cuentas/accounts?customer_id=' +
          userId.toString());
  if (response.statusCode == 200) {
    Map<String, dynamic> body = convert.jsonDecode(response.body);
    List<dynamic> res = body['response']['message'];
    accounts = res.map((dynamic item) => Account.fromJson(item)).toList();
  } else {
    print("Errro consultando las cuentas cliente " + userId.toString());
    //throw "Can't get accounts.";
  }

  return accounts;
}
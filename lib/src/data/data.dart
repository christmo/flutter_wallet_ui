import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/models/account.dart';
import 'package:flutter_wallet_ui_challenge/src/models/card_movements.dart';
import 'package:flutter_wallet_ui_challenge/src/models/customer.dart';
import 'package:flutter_wallet_ui_challenge/src/models/movement.dart';
import 'package:flutter_wallet_ui_challenge/src/models/payment_model.dart';
import 'package:flutter_wallet_ui_challenge/src/models/transfer_account.dart';
import 'package:flutter_wallet_ui_challenge/src/models/user_model.dart';
import 'package:http/http.dart' as http;

import '../models/card8a.dart';

String apikey='apikey=nVSz0waWCsiivu6OAH0M8Blg8gqQEWHA';

List<UserModel> getUsersCard() {
  List<UserModel> userCards = [
    UserModel("Adrian", "assets/images/users/adrian.jpeg", 1),
    UserModel("Karla", "assets/images/users/karla.jpeg", 3),
    UserModel("Xavi", "assets/images/users/xavi.jpeg", 2),
    UserModel("Christian", "assets/images/users/chris.jpeg", 4),
    UserModel("Ivan", "assets/images/users/ivan.jpeg", 5),
  ];

  return userCards;
}

String getLogo(String brand) {
  if (brand.contains("Visa")) {
    //return "https://resources.mynewsdesk.com/image/upload/ojf8ed4taaxccncp6pcp.png";
    return "assets/images/visa.png";
  }
  //return "https://kvillacreses-eval-diners.apigee.io/files/dc-logo.png";
  return "assets/images/dc-logo.png";
}

Widget loadCardImage(bool isDiners, String logo, double position) {
  if (isDiners) {
    return Positioned(
      top: position,
      right: position,
      child: Container(
        height: 25,
        width: 50,
        child: Image.asset(logo),
      ),
    );
  } else {
    return Positioned(
      top: position,
      right: position,
      child: Container(
        height: 25,
        width: 50,
        color: Colors.pink,
        padding: EdgeInsets.all(7),
        child: Image.asset(logo, color: Colors.white),
        /*Image.network(
            logo,
            width: 50,
            color: Colors.white,
          ),*/
      ),
    );
  }
}

Future<List<Card8A>> queryCards(int user) async {
  print("Getting cards from User: " + user.toString());
  try {
    http.Response response = await http.get(
        'https://kvillacreses-eval-prod.apigee.net/tarjetas/credit_cards?$apikey&customer_id=' +
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
  } on Exception catch (e) {
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

Future<List<Customer>> getCustomers() async {
  List<Customer> customers = new List();
  var client = new http.Client();
  http.Response response = await client
      .get('https://kvillacreses-eval-prod.apigee.net/clientes/customers');
  if (response.statusCode == 200) {
    Map<String, dynamic> body = convert.jsonDecode(response.body);
    List<dynamic> res = body['response']['message'];
    customers = res.map((dynamic item) => Customer.fromJson(item)).toList();
  } else {
    throw "Error consultando los clientes";
  }

  return customers;
}

Future<List<Movement>> getMovementsAccounts(String account) async {
  List<Movement> movements = new List();
  var client = new http.Client();
  http.Response response = await client.get(
      'https://kvillacreses-eval-prod.apigee.net/pagos/movements?account=' +
          account);
  if (response.statusCode == 200) {
    Map<String, dynamic> body = convert.jsonDecode(response.body);
    List<dynamic> res = body['response']['message'];
    movements = res.map((dynamic item) => Movement.fromJson(item)).toList();
  } else {
    throw "Error consultando los clientes";
  }

  return movements;
}

Future<CardMovements> getMovementsCards(String card, String brand) async {
  CardMovements cardMovements = CardMovements();
  List<Movement> movements = List();
  var client = new http.Client();
  http.Response response = await client.get(
      'https://kvillacreses-eval-prod.apigee.net/tarjetas/credit_cards/statement?$apikey&number=' +
          card +
          '&brand=' +
          brand);
  if (response.statusCode == 200) {
    Map<String, dynamic> body = convert.jsonDecode(response.body);
    List<dynamic> resMovements = body['response']['message']['movements'];
    Map<String, dynamic> res = body['response']['message'];
    movements =
        resMovements.map((dynamic item) => Movement.fromJson(item)).toList();
    cardMovements = CardMovements.fromJson(res);
    cardMovements.movements = movements;
  } else {
    throw "Error consultando los movimientos";
  }

  return cardMovements;
}

Future<List<ProductModel>> consolidation(int userId) async {
  List<Account> accounts = await getAccount(userId);
  List<Card8A> cards = await queryCards(userId);
  List<ProductModel> productAccounts = accounts
      .map((Account acc) => ProductModel(
          Icons.monetization_on,
          Color(0xFFffd60f),
          acc.alias + " - " + acc.obfuscated,
          acc.number,
          acc.type,
          double.parse(acc.available_balance),
          1,
          acc.alias,
          acc.obfuscated,
          ""))
      .toList();

  List<ProductModel> productCards = cards
      .map((Card8A card) => ProductModel(
          Icons.credit_card,
          getBrandColor(card.brand),
          card.brand,
          card.number,
          "creditcard",
          double.parse(card.available_quota),
          1,
          card.brand,
          card.number.replaceAll("-", ""),
          card.next_payment_day))
      .toList();

  return List.from(productCards)..addAll(productAccounts);
}

Color getBrandColor(String brand) {
  if (brand.contains("Diners")) {
    return Color(0xFF000080);
  } else {
    return Color(0xFF000000);
  }
}

Future<List<TransferAccount>> joinProductsTransfer(
    int userId, bool removeLoan) async {
  List<Account> accounts = await getAccount(userId);
  List<TransferAccount> listAcc = accounts
      .map((Account acc) =>
          TransferAccount(number: acc.number, brand: acc.alias, type: acc.type))
      .toList();
  if(removeLoan) {
    listAcc =
        listAcc.where((TransferAccount acc) => acc.type != 'loan').toList();
  }
  List<Card8A> cards = await queryCards(userId);
  List<TransferAccount> listCard = cards
      .map((Card8A card) => TransferAccount(
          number: card.number, brand: card.brand, type: "creditcard"))
      .toList();

  return listCard + listAcc;
}

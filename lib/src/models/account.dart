import 'package:flutter/foundation.dart';

class Account {
  final String alias;
  final String available_balance;
  final String customer_id;
  final String number;
  final String obfuscated;
  final String type;

  Account({
    @required this.alias,
    @required this.available_balance,
    @required this.customer_id,
    @required this.number,
    @required this.obfuscated,
    @required this.type,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      alias: json['alias'] as String,
      available_balance: json['available_balance'] as String,
      customer_id: json['customer_id'] as String,
      number: json['number'] as String,
      obfuscated: json['obfuscated'] as String,
      type: json['type'] as String,
    );
  }
}
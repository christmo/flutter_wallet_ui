import 'package:flutter/foundation.dart';

class Card8A {
  final String alias;
  final String available_quota;
  final String brand;
  final int court_date;
  final String customer_id;
  final String next_payment_day;
  final String number;
  final String obfuscated;

  Card8A({
    @required this.alias,
    @required this.available_quota,
    @required this.brand,
    @required this.court_date,
    @required this.customer_id,
    @required this.next_payment_day,
    @required this.number,
    @required this.obfuscated,
  });

  factory Card8A.fromJson(Map<String, dynamic> json) {
    return Card8A(
      alias: json['alias'] as String,
      available_quota: json['available_quota'] as String,
      brand: json['brand'] as String,
      court_date: int.parse(json['court_date'].toString()),
      customer_id: json['customer_id'] as String,
      next_payment_day: json['next_payment_day'] as String,
      number: json['number'] as String,
      obfuscated: json['obfuscated'] as String,
    );
  }
}
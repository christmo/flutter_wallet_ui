import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Movement {
  final String account;
  final String after;
  final String amount;
  final String before;
  final String date;
  final String description;
  final String transaction_id;
  final String type;
  IconData icon;
  Color color;

  Movement({
    @required this.account,
    @required this.after,
    @required this.amount,
    @required this.before,
    @required this.date,
    @required this.description,
    @required this.transaction_id,
    @required this.type,
    this.icon,
    this.color,
  });

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      account: json['account'] as String,
      after: json['after'] as String,
      amount: json['amount'] as String,
      before: json['before'] as String,
      date: json['date'] as String,
      description: json['description'] as String,
      transaction_id: json['transaction_id'] as String,
      type: json['type'] as String,
      icon: json['type'] as String == 'CREDIT' ? Icons.add: Icons.keyboard_arrow_down,
      color: json['type'] as String == 'CREDIT' ? Color(0xFF389626) : Color(0xFFff2a12),
    );
  }
}
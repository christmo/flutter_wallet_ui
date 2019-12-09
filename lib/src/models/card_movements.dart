import 'package:flutter/foundation.dart';

import 'movement.dart';

class CardMovements {
  final String credit_card;
  final String last_court_day;
  final String next_court_day;
  final String next_payment_day;
  final String total_to_payment;
  List<Movement> movements;

  CardMovements(
      {@required this.credit_card,
      @required this.last_court_day,
      @required this.next_court_day,
      @required this.next_payment_day,
      @required this.total_to_payment});

  factory CardMovements.fromJson(Map<String, dynamic> json) {
    return CardMovements(
        credit_card: json['credit_card'] as String,
        last_court_day: json['last_court_day'] as String,
        next_court_day: json['next_court_day'] as String,
        next_payment_day: json['next_payment_day'] as String,
        total_to_payment: json['total_to_payment'] as String
    );
  }
}

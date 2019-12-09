import 'package:flutter/material.dart';

class ProductModel {
  IconData _icon;
  String _name, _number, _type;
  String _brand, _obfuscated;
  String _paymentDay;
  Color _color;
  double _amount;
  int _paymentType;

  ProductModel(this._icon, this._color, this._name, this._number, this._type,
      this._amount, this._paymentType, this._brand, this._obfuscated, this._paymentDay);

  String get name => _name;

  String get number => _number;

  String get type => _type;
  String get brand => _brand;
  String get obfuscated => _obfuscated;
  String get paymentDay => _paymentDay;

  double get amount => _amount;

  int get paymentType => _paymentType;

  IconData get icon => _icon;

  Color get color => _color;

  bool get isDiners{
    if (_brand.contains("Visa")) {
      return false;
    }
    return true;
  }
}

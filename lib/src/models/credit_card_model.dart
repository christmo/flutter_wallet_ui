class CreditCardModel {
  final String _cardNo, _expiryDate, _cvv, _logo;
  final bool type; //true diners

  CreditCardModel(this._cardNo, this._logo, this._expiryDate, this._cvv, this.type)
      : assert(_cardNo.length >= 14);

  String get cardNo {
    var letters = [];
    String cardNumber = _cardNo.replaceAll("-", "");
    cardNumber = cardNumber.length == 16 ? cardNumber : "00" + cardNumber;
    for (int i = 0; i < cardNumber.length;) {
      letters.add(cardNumber.substring(i, ((i ~/ 4) + 1) * 4));
      i += 4;
    }
    var fakeCardNo = "";
    for (int i = 0; i < letters.length; i++) {
      if (i == letters.length - 1) {
        fakeCardNo += letters[i];
        break;
      }
      fakeCardNo += "****    ";
    }
    return fakeCardNo;
  }

  String get logo => _logo;

  String get cvv => _cvv;

  String get expiryDate => _expiryDate;
}

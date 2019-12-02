class UserModel{
  String _name,_profilePic;
  int code;

  UserModel(this._name, this._profilePic, this.code);

  String get name => _name;

  get profilePic => _profilePic;

  int get userId => code;
}
class UserModel {

  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? account_type;

  UserModel({this.uid, this.email, this.firstName, this.secondName, this.account_type });

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      account_type: map['account_type'],

    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'account_type': account_type,
    };
  }
}

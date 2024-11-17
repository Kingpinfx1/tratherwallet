class User {
  int user_id;
  String user_firstname;
  String user_lastname;
  String user_address;
  String user_email;
  String user_password;
  String user_balance;

  User({
    required this.user_id,
    required this.user_firstname,
    required this.user_lastname,
    required this.user_address,
    required this.user_email,
    required this.user_password,
    required this.user_balance,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        user_id: int.parse(json["user_id"]),
        user_firstname: json["user_firstname"].toString(),
        user_lastname: json["user_lastname"].toString(),
        user_address: json["user_address"].toString(),
        user_email: json["user_email"].toString(),
        user_password: json["user_password"].toString(),
        user_balance: json["user_balance"].toString(),
      );

  Map<String, dynamic> toJson() => {
        'user_id': user_id.toString(),
        'user_firstname': user_firstname,
        'user_lastname': user_lastname,
        'user_address': user_address,
        'user_email': user_email,
        'user_password': user_password,
        'user_balance': user_balance,
      };
}

class PaymentMethods {
  int id;
  String name;
  String description;
  String image;

  PaymentMethods({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory PaymentMethods.fromJson(Map<String, dynamic> json) => PaymentMethods(
        id: int.parse(json["id"]),
        name: json["name"].toString(),
        description: json['description'].toString(),
        image: json['image'].toString(),
      );
}

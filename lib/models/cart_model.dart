class CartModel {
  final String title;
  final double price;
  final String image;
  final int quantity;

  CartModel({
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
  });

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      title: map['title'],
      price: (map['price'] as num).toDouble(),
      image: map['image'],
      quantity: map['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }
}

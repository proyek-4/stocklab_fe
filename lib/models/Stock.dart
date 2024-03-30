class Stock {
  final int id, price, quantity;
  final String name, description, image;

  Stock(
      {this.id = 0,
      this.price = 0,
      this.quantity = 0,
      this.name = '',
      this.description = '',
      this.image = ''});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      price: json['price'],
      quantity: json['quantity'],
      name: json['name'],
      description: json['description'] ?? '-',
      image: json['image'],
    );
  }
}

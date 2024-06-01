class Stock {
  final int id, price, cost, quantity, warehouse_id;
  final String name, description, image, date;
  int selectedQuantity;

  Stock(
      {this.id = 0,
      this.price = 0,
      this.cost = 0,
      this.quantity = 0,
      this.name = '',
      this.description = '',
      this.image = '',
      this.date = '',
      this.warehouse_id = 0,
      this.selectedQuantity = 0,});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      price: json['price'],
      cost: json['cost'],
      quantity: json['quantity'],
      name: json['name'],
      description: json['description'] ?? '-',
      image: json['image'],
      date: json['date'],
      warehouse_id: json['warehouse_id'],
    );
  }
}

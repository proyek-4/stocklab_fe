class Record {
  final int id, stock_id, quantity;
  final String name, date, record_type;
  final double debit, kredit, saldo;

  Record(
      {this.id = 0,
        this.stock_id = 0,
        this.quantity = 0,
        this.name = '',
        this.date = '',
        this.debit = 0,
        this.kredit = 0,
        this.saldo = 0,
        this.record_type = '',
      });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'],
      stock_id: json['stock_id'],
      quantity: json['quantity'],
      name: json['name'],
      date: json['date'],
      debit: double.tryParse(json['debit']) ?? 0.0,
      kredit: double.tryParse(json['kredit']) ?? 0.0,
      saldo: double.tryParse(json['saldo']) ?? 0.0,
      record_type: json['record_type'],
    );
  }
}

class Bill {
  final String id;
  final String description;
  final double amount;

  Bill({
    required this.id,
    required this.description,
    required this.amount,
  });

  Bill copyWith({
    String? id,
    String? description,
    double? amount,
  }) {
    return Bill(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
    );
  }
}

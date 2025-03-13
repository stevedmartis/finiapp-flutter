class PaymentDto {
  final String id;
  final String description;
  final double amount;
  final DateTime dueDate;
  final String category;
  final bool isPaid;
  final bool isRecurring;
  final String frequency; // "monthly", "weekly", etc.

  PaymentDto({
    required this.id,
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.category,
    this.isPaid = false,
    this.isRecurring = false,
    this.frequency = "monthly",
  });

  // Factory para crear desde un Map (para JSON)
  factory PaymentDto.fromJson(Map<String, dynamic> json) {
    return PaymentDto(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      category: json['category'] as String,
      isPaid: json['isPaid'] as bool? ?? false,
      isRecurring: json['isRecurring'] as bool? ?? false,
      frequency: json['frequency'] as String? ?? 'monthly',
    );
  }

  // Método para convertir a Map (para JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'category': category,
      'isPaid': isPaid,
      'isRecurring': isRecurring,
      'frequency': frequency,
    };
  }

  // Método para crear una copia con cambios
  PaymentDto copyWith({
    String? id,
    String? description,
    double? amount,
    DateTime? dueDate,
    String? category,
    bool? isPaid,
    bool? isRecurring,
    String? frequency,
  }) {
    return PaymentDto(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      isPaid: isPaid ?? this.isPaid,
      isRecurring: isRecurring ?? this.isRecurring,
      frequency: frequency ?? this.frequency,
    );
  }
}

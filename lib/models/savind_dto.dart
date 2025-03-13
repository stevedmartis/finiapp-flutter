class SavingGoalDto {
  final String id;
  final String name;
  final String category;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final String? iconName; // Opcional, para iconos personalizados
  final String? description;

  SavingGoalDto({
    required this.id,
    required this.name,
    required this.category,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    this.iconName,
    this.description,
  });

  // Factory para crear desde un Map (para JSON)
  factory SavingGoalDto.fromJson(Map<String, dynamic> json) {
    return SavingGoalDto(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      targetDate: DateTime.parse(json['targetDate'] as String),
      iconName: json['iconName'] as String?,
      description: json['description'] as String?,
    );
  }

  // Método para convertir a Map (para JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate.toIso8601String(),
      'iconName': iconName,
      'description': description,
    };
  }

  // Método para crear una copia con cambios
  SavingGoalDto copyWith({
    String? id,
    String? name,
    String? category,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
    String? iconName,
    String? description,
  }) {
    return SavingGoalDto(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      iconName: iconName ?? this.iconName,
      description: description ?? this.description,
    );
  }

  // Calcular el progreso como porcentaje
  double get progressPercentage => (currentAmount / targetAmount) * 100;

  // Verificar si la meta está completada
  bool get isCompleted => currentAmount >= targetAmount;

  // Calcular los días restantes
  int get daysRemaining => targetDate.difference(DateTime.now()).inDays;
}

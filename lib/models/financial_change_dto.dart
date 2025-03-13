class FinancialChallengeDto {
  final String id;
  final String title;
  final String description;
  final String type; // "saving", "spending", "budget", "debt"
  final int durationDays;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final bool isCompleted;
  final double? targetAmount; // Para desafíos con objetivo monetario
  final double? currentAmount; // Progreso actual

  FinancialChallengeDto({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.durationDays,
    required this.startDate,
    this.endDate,
    this.isActive = false,
    this.isCompleted = false,
    this.targetAmount,
    this.currentAmount,
  });

  // Factory para crear desde un Map (para JSON)
  factory FinancialChallengeDto.fromJson(Map<String, dynamic> json) {
    return FinancialChallengeDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      durationDays: json['durationDays'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
      targetAmount: json['targetAmount'] != null
          ? (json['targetAmount'] as num).toDouble()
          : null,
      currentAmount: json['currentAmount'] != null
          ? (json['currentAmount'] as num).toDouble()
          : null,
    );
  }

  // Método para convertir a Map (para JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'durationDays': durationDays,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'isCompleted': isCompleted,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
    };
  }

  // Calcular días restantes
  int get daysRemaining {
    if (endDate != null) {
      return endDate!.difference(DateTime.now()).inDays;
    } else if (isActive) {
      final DateTime calculatedEndDate =
          startDate.add(Duration(days: durationDays));
      return calculatedEndDate.difference(DateTime.now()).inDays;
    }
    return durationDays;
  }

  // Calcular progreso como porcentaje
  double get progressPercentage {
    if (targetAmount != null && currentAmount != null) {
      return (currentAmount! / targetAmount!) * 100;
    } else if (endDate != null) {
      final int totalDays = endDate!.difference(startDate).inDays;
      final int elapsedDays = totalDays - daysRemaining;
      return (elapsedDays / totalDays) * 100;
    }
    return 0;
  }

  // Método para crear una copia con cambios
  FinancialChallengeDto copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    int? durationDays,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    bool? isCompleted,
    double? targetAmount,
    double? currentAmount,
  }) {
    return FinancialChallengeDto(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      durationDays: durationDays ?? this.durationDays,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
    );
  }
}

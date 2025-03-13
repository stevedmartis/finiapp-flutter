class FinancialTipDto {
  final String id;
  final String title;
  final String description;
  final String type; // 'saving', 'spending', 'investment', 'alert', 'general'
  final double? potentialSaving; // Cuánto podría ahorrar siguiendo este consejo
  final String? actionUrl; // URL o ruta para tomar acción sobre este consejo

  FinancialTipDto({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.potentialSaving,
    this.actionUrl,
  });

  // Factory para crear desde un Map (para JSON)
  factory FinancialTipDto.fromJson(Map<String, dynamic> json) {
    return FinancialTipDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      potentialSaving: json['potentialSaving'] != null
          ? (json['potentialSaving'] as num).toDouble()
          : null,
      actionUrl: json['actionUrl'] as String?,
    );
  }

  // Método para convertir a Map (para JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'potentialSaving': potentialSaving,
      'actionUrl': actionUrl,
    };
  }
}

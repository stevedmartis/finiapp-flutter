String formatAbrevCurrency(double amount) {
  // Para números negativos, manejamos el signo por separado
  bool isNegative = amount < 0;
  double absAmount = amount.abs();
  String prefix = isNegative ? "-\$" : "\$";

  if (absAmount >= 1e9) {
    // Billones (B)
    double value = absAmount / 1e9;
    // Eliminar el decimal si es un número entero
    return value % 1 == 0
        ? '$prefix${value.toInt()}B'
        : '$prefix${value.toStringAsFixed(1)}B';
  } else if (absAmount >= 1e6) {
    // Millones (M)
    double value = absAmount / 1e6;
    return value % 1 == 0
        ? '$prefix${value.toInt()}M'
        : '$prefix${value.toStringAsFixed(1)}M';
  } else if (absAmount >= 1e3) {
    // Miles (K)
    double value = absAmount / 1e3;
    return value % 1 == 0
        ? '$prefix${value.toInt()}K'
        : '$prefix${value.toStringAsFixed(1)}K';
  } else {
    // Para valores menores a mil
    if (absAmount % 1 == 0) {
      // Si es un número entero
      return '$prefix${absAmount.toInt()}';
    } else {
      // Con decimales
      return '$prefix${absAmount.toStringAsFixed(2)}';
    }
  }
}

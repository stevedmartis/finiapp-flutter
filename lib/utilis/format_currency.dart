import 'package:intl/intl.dart';

String formatAbrevCurrency(double amount) {
  if (amount.abs() >= 1e9) {
    // Si es mayor a mil millones → Billones (B)
    return '\$${(amount / 1e9).toStringAsFixed(1)}B';
  } else if (amount.abs() >= 1e6) {
    // Si es mayor a un millón → Millones (M)
    return '\$${(amount / 1e6).toStringAsFixed(1)}M';
  } else if (amount.abs() >= 1e3) {
    // Si es mayor a mil → Miles (K)
    return '\$${(amount / 1e3).toStringAsFixed(1)}K';
  } else {
    // ✅ Si es menor a mil → Formato tradicional
    final NumberFormat format =
        NumberFormat.currency(locale: 'es_CL', symbol: '');
    String formatted = format.format(amount);
    formatted = formatted
        .replaceAll('\$', '')
        .replaceAll(',', ''); // Eliminar símbolo y separador de miles

    // ✅ Mostrar sin decimales
    return '\$${formatted.substring(0, formatted.length - 3)}';
  }
}

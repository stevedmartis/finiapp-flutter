import 'package:finia_app/models/payment_dto.dart';

class PaymentService {
  // Lista de pagos próximos
  List<PaymentDto> _upcomingPayments = [];

  // Método para obtener pagos próximos
  List<PaymentDto> getUpcomingPayments() {
    // Ordenar por fecha de vencimiento
    _upcomingPayments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return _upcomingPayments;
  }

  // Método para añadir un nuevo pago
  void addPayment(PaymentDto payment) {
    _upcomingPayments.add(payment);
  }

  // Método para marcar un pago como pagado
  void markAsPaid(String paymentId) {
    final index = _upcomingPayments.indexWhere((p) => p.id == paymentId);
    if (index != -1) {
      _upcomingPayments[index] =
          _upcomingPayments[index].copyWith(isPaid: true);
    }
  }

  // Método para eliminar un pago
  void deletePayment(String paymentId) {
    _upcomingPayments.removeWhere((p) => p.id == paymentId);
  }

  // Método para actualizar un pago
  void updatePayment(PaymentDto updatedPayment) {
    final index =
        _upcomingPayments.indexWhere((p) => p.id == updatedPayment.id);
    if (index != -1) {
      _upcomingPayments[index] = updatedPayment;
    }
  }

  // Método para generar pagos recurrentes
  void generateRecurringPayments() {
    // Implementación para crear nuevas instancias de pagos recurrentes
    // cuando los anteriores ya han sido pagados
  }
}

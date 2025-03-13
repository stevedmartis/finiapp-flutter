import 'package:finia_app/models/savind_dto.dart';

class SavingGoalService {
  // Lista de metas de ahorro
  List<SavingGoalDto> _savingGoals = [];

  // Método para obtener todas las metas
  List<SavingGoalDto> getAllGoals() {
    return _savingGoals;
  }

  // Método para añadir una nueva meta
  void addGoal(SavingGoalDto goal) {
    _savingGoals.add(goal);
  }

  // Método para actualizar el progreso de una meta
  void updateGoalProgress(String goalId, double amount) {
    final index = _savingGoals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final currentAmount = _savingGoals[index].currentAmount + amount;
      _savingGoals[index] =
          _savingGoals[index].copyWith(currentAmount: currentAmount);
    }
  }

  // Método para eliminar una meta
  void deleteGoal(String goalId) {
    _savingGoals.removeWhere((g) => g.id == goalId);
  }

  // Método para obtener metas completadas
  List<SavingGoalDto> getCompletedGoals() {
    return _savingGoals.where((g) => g.isCompleted).toList();
  }

  // Método para obtener metas activas
  List<SavingGoalDto> getActiveGoals() {
    return _savingGoals.where((g) => !g.isCompleted).toList();
  }
}

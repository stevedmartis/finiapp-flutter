import 'package:finia_app/models/finance_summary.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FinancialDataService with ChangeNotifier {
  FinancialData? _financialData;

  FinancialData? get financialData => _financialData;

  void updateFinancialData(FinancialData newData) {
    _financialData = newData;
    notifyListeners();
  }

  Future<void> fetchFinancialSummary(String userId) async {
    var url = Uri.parse('http://localhost:3000/finance/summary/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Verifica si la respuesta tiene un cuerpo no vacío antes de intentar analizarla
        if (response.body.isNotEmpty) {
          final parsedData = FinancialData.fromJsonString(response.body);
          updateFinancialData(
              parsedData); // Actualiza los datos y notifica a los oyentes
        } else {
          throw Exception('Empty response body');
        }
      } else {
        throw Exception(
            'Failed to load financial summary with status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load financial summary: $e');
    }
  }
}

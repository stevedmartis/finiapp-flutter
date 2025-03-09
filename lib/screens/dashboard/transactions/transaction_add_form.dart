import 'package:finia_app/screens/dashboard/components/header_custom.dart';
import 'package:finia_app/services/accounts_services.dart';
import 'package:finia_app/services/finance_summary_service.dart';
import 'package:finia_app/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  final String? accountId;
  const AddTransactionBottomSheet({super.key, this.accountId});

  @override
  AddTransactionBottomSheetState createState() =>
      AddTransactionBottomSheetState();
}

class AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  late TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  int _selectedCategoryIndex = 0;
  bool _isIncome = true;
  bool _showMoreCategories = false;
  DateTime _selectedDate = DateTime.now();
  bool _isEditing = false;
  String? _selectedAccountId;

  final List<Map<String, dynamic>> _categories = [
    {"icon": Icons.fastfood, "label": "Comida"},
    {"icon": Icons.directions_car, "label": "Transporte"},
    {"icon": Icons.health_and_safety, "label": "Salud"},
    {"icon": Icons.movie, "label": "Ocio"},
    {"icon": Icons.school, "label": "Educación"},
    {"icon": Icons.local_gas_station, "label": "Gasolina"},
    {"icon": Icons.directions_car_filled, "label": "Uber / Taxi"},
    {"icon": Icons.tv, "label": "Streaming"},
    {"icon": Icons.home, "label": "Hogar"},
    {"icon": Icons.pets, "label": "Mascota"},
  ];

  final List<Map<String, dynamic>> _extraCategories = [
    {"icon": Icons.shopping_bag, "label": "Ropa"},
    {"icon": Icons.sports_esports, "label": "Videojuegos"},
    {"icon": Icons.fitness_center, "label": "Gimnasio"},
    {"icon": Icons.card_giftcard, "label": "Regalos"},
    {"icon": Icons.flight_takeoff, "label": "Viajes"},
    {"icon": Icons.savings, "label": "Ahorro"},
  ];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    // ✅ Si viene desde una cuenta → se preselecciona automáticamente
    _selectedAccountId = widget.accountId ??
        Provider.of<AccountsProvider>(context, listen: false).currentAccountId;
  }

  /// 🔹 **Función para formatear la cantidad automáticamente**
  void _onBalanceChanged(TextEditingController controller, String value) {
    if (_isEditing) return; // Evita llamadas múltiples innecesarias
    _isEditing = true;

    // Eliminar cualquier formato previo para obtener solo números
    String cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    double balance = double.tryParse(cleanValue) ?? 0;

    // Aplicar formateo en el TextField sin afectar cálculos
    String formattedValue = formatCurrency(balance);
    controller.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );

    _isEditing = false;
  }

  List<Map<String, dynamic>> get _allCategories =>
      List.from(_categories)..addAll(_extraCategories);

  void _saveTransaction() {
    String cleanBalance =
        _amountController.text.replaceAll(RegExp(r'[^\d]'), '');
    double amount = double.tryParse(cleanBalance) ?? 0;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor ingresa un monto válido."),
        ),
      );
      return;
    }

    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    final financialProvider =
        Provider.of<FinancialDataService>(context, listen: false);

    if (_selectedCategoryIndex < 0 ||
        _selectedCategoryIndex >= _allCategories.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor selecciona una categoría válida.')),
      );
      return;
    }

    // ✅ Usa _allCategories en lugar de _categories
    String selectedCategory = _allCategories[_selectedCategoryIndex]['label'];

    print("✅ Categoría seleccionada: $selectedCategory");

    final String transactionId = const Uuid().v4();
    TransactionDto newTransaction = TransactionDto(
      id: transactionId,
      type: _isIncome ? "Ingreso" : "Gasto",
      amount: amount,
      category: selectedCategory,
      date: DateFormat('dd-MM-yyyy').format(_selectedDate),
      note: _noteController.text,
      accountId: _selectedAccountId!,
    );

    transactionProvider.addTransaction(newTransaction);
    financialProvider.addTransactionToSummary(newTransaction);

    setState(() {
      _selectedCategoryIndex = -1; // ✅ Reset después de guardar
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final accountsProvider = Provider.of<AccountsProvider>(context);
    final accounts = accountsProvider.accounts;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: _showMoreCategories ? 1.0 : 0.75,
      minChildSize: 0.5,
      maxChildSize: _showMoreCategories ? 1.0 : 0.75,
      builder: (context, scrollController) {
        return Container(
          padding:
              EdgeInsets.fromLTRB(16, _showMoreCategories ? 45 : 24, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 Título con mejor UX
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Registrar movimiento",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // 🔹 Selector de Tipo de Transacción
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    showCheckmark: false,
                    avatar: Icon(Icons.arrow_upward,
                        color: _isIncome ? Colors.white : Colors.green),
                    label: Text("Ingreso"),
                    selected: _isIncome,
                    selectedColor: Colors.green,
                    backgroundColor: Colors.black26,
                    onSelected: (val) => setState(() => _isIncome = true),
                    labelStyle: TextStyle(
                        color: _isIncome ? Colors.white : Colors.green),
                  ),
                  SizedBox(width: 10),
                  ChoiceChip(
                    showCheckmark: false,
                    avatar: Icon(Icons.arrow_downward,
                        color: !_isIncome ? Colors.white : Colors.red),
                    label: Text("Gasto"),
                    selected: !_isIncome,
                    selectedColor: Colors.red,
                    backgroundColor: Colors.black26,
                    onSelected: (val) => setState(() => _isIncome = false),
                    labelStyle: TextStyle(
                        color: !_isIncome ? Colors.white : Colors.red),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // ✅ Seleccionar cuenta
              DropdownButtonFormField(
                value: _selectedAccountId,
                onChanged: (value) {
                  setState(() {
                    _selectedAccountId = value as String;
                  });
                },
                items: accounts.map((account) {
                  return DropdownMenuItem(
                    value: account.id,
                    child: Text(account.name),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Cuenta',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Campo de Monto con Formateo Automático

              _buildTextField("Monto", _amountController,
                  isNumeric: true, onChanged: (value) {}),
              const SizedBox(height: 20),

              // 🔹 Categorías (2 filas por defecto)
              const Text("Categoría", style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._categories
                      .take(10)
                      .map((category) => _buildCategoryChip(category)),
                  if (_showMoreCategories)
                    ..._extraCategories
                        .map((category) => _buildCategoryChip(category)),
                ],
              ),
              const SizedBox(height: 10),
              // 🔹 Botón "Ver más"
              TextButton(
                onPressed: () {
                  setState(() {
                    _showMoreCategories = !_showMoreCategories;
                  });
                },
                child: Text(
                  _showMoreCategories ? "Ver menos" : "Ver más categorías",
                  style: const TextStyle(color: Colors.purpleAccent),
                ),
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isIncome
                        ? Colors.green
                        : Colors.red, // Usa el color principal de la app
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveTransaction,
                  child: Text(
                    "Agregar ${_isIncome ? 'Ingreso' : 'Gasto'} ",
                    style: const TextStyle(
                      color: Colors.white, // Asegura buen contraste
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              // 🔹 Botón de Guardar en el Footer
              /*  Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton.icon(
                    onPressed: _saveTransaction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isIncome ? Colors.green : Colors.red,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(Icons.save, color: Colors.white),
                    label: Text("Guardar Transacción",
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
              ), */
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumeric = false, Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      onChanged: (value) {
        if (isNumeric) {
          _onBalanceChanged(controller, value);
        }
        if (onChanged != null) {
          onChanged(value);
        }
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoryChip(Map<String, dynamic> category) {
    int index = _categories.indexOf(category);
    if (index == -1) {
      index = _categories.length + _extraCategories.indexOf(category);
    }
    return GestureDetector(
      onTap: () => setState(() => _selectedCategoryIndex = index),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: _selectedCategoryIndex == index
                ? Colors.blue
                : Colors.grey[800],
            child: Icon(category['icon'], color: Colors.white),
          ),
          SizedBox(height: 5),
          Text(category['label'],
              style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

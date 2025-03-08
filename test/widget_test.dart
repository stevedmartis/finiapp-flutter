import 'package:finia_app/services/accounts_services.dart';
import 'package:finia_app/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finia_app/screens/main/main_screen.dart';
import 'package:finia_app/main.dart';
import 'package:mockito/mockito.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:finia_app/services/auth_service.dart';
import 'package:provider/provider.dart';

// Mocks para InterceptedClient, AuthService y AccountsProvider
class MockClient extends Mock implements InterceptedClient {}

class MockAuthService extends Mock implements AuthService {}

class MockAccountsProvider extends Mock implements AccountsProvider {}

class MockTransactionProvider extends Mock implements TransactionProvider {}

void main() {
  testWidgets('MyApp utiliza las dependencias simuladas',
      (WidgetTester tester) async {
    // Crea instancias simuladas
    final mockClient = MockClient();
    final mockAuthService = MockAuthService();
    final mockAccountsProvider = MockAccountsProvider();
    final mockTransactionProvider = MockTransactionProvider();
    // 🔹 Simular que el usuario ya completó el onboarding
    bool hasCompletedOnboarding = true;

    // Construye la aplicación utilizando las instancias simuladas
    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            Provider<InterceptedClient>.value(value: mockClient),
            ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
            ChangeNotifierProvider<AccountsProvider>.value(
                value: mockAccountsProvider),
            ChangeNotifierProvider<TransactionProvider>.value(
                value: mockTransactionProvider),
          ],
          child: MyApp(
              client: mockClient,
              authService: mockAuthService,
              hasCompletedOnboarding:
                  hasCompletedOnboarding, // ✅ Se agregó este argumento
              accountsProvider: mockAccountsProvider,
              transactionProvider: mockTransactionProvider),
        ),
      ),
    );

    // ✅ Verifica que `MainScreen` se encuentra en la jerarquía de widgets
    expect(find.byType(MainScreen), findsOneWidget);
  });
}

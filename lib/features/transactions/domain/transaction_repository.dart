import 'finance_transaction.dart';

abstract class TransactionRepository {
  Stream<List<FinanceTransaction>> watchTransactions(String userId);

  Future<void> add(String userId, FinanceTransaction transaction);

  Future<void> delete(String userId, String transactionId);
}
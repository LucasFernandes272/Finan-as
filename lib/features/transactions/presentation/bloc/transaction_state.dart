import 'package:equatable/equatable.dart';

import '../../domain/finance_transaction.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionState extends Equatable {
  final TransactionsStatus status;
  final List<FinanceTransaction> transactions;
  final String? errorMessage;

  const TransactionState({
    this.status = TransactionsStatus.initial,
    this.transactions = const [],
    this.errorMessage,
  });

  double get totalIncome => transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  TransactionState copyWith({
    TransactionsStatus? status,
    List<FinanceTransaction>? transactions,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, transactions, errorMessage];
}
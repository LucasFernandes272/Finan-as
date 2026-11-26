import 'package:equatable/equatable.dart';

import '../../domain/finance_transaction.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class TransactionsWatchStarted extends TransactionEvent {
  final String userId;

  const TransactionsWatchStarted(this.userId);

  @override
  List<Object?> get props => [userId];
}

class TransactionAdded extends TransactionEvent {
  final FinanceTransaction transaction;

  const TransactionAdded(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionDeleted extends TransactionEvent {
  final String transactionId;

  const TransactionDeleted(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}
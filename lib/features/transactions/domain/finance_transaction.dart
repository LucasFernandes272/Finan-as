import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

class FinanceTransaction extends Equatable {
  final String id;
  final String description;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;

  const FinanceTransaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  @override
  List<Object?> get props => [id, description, amount, type, category, date];
}
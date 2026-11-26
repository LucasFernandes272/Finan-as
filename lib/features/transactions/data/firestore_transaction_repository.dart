import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/finance_transaction.dart';
import '../domain/transaction_repository.dart';

class FirestoreTransactionRepository implements TransactionRepository {
  final FirebaseFirestore _firestore;

  FirestoreTransactionRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions');
  }

  @override
  Stream<List<FinanceTransaction>> watchTransactions(String userId) {
    return _collection(userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => _fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  @override
  Future<void> add(String userId, FinanceTransaction transaction) async {
    await _collection(userId).add(_toMap(transaction));
  }

  @override
  Future<void> delete(String userId, String transactionId) async {
    await _collection(userId).doc(transactionId).delete();
  }

  Map<String, dynamic> _toMap(FinanceTransaction t) {
    return {
      'description': t.description,
      'amount': t.amount,
      'type': t.type.name,
      'category': t.category,
      'date': Timestamp.fromDate(t.date),
    };
  }

  FinanceTransaction _fromMap(String id, Map<String, dynamic> map) {
    return FinanceTransaction(
      id: id,
      description: map['description'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      type: TransactionType.values.byName(map['type'] as String),
      category: map['category'] as String? ?? 'Outros',
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
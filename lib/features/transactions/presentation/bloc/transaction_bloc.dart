import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/finance_transaction.dart';
import '../../domain/transaction_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;
  String? _userId;

  TransactionBloc({required TransactionRepository repository})
      : _repository = repository,
        super(const TransactionState()) {
    on<TransactionsWatchStarted>(_onWatchStarted);
    on<TransactionAdded>(_onAdded);
    on<TransactionDeleted>(_onDeleted);
  }

  Future<void> _onWatchStarted(
      TransactionsWatchStarted event,
      Emitter<TransactionState> emit,
      ) async {
    _userId = event.userId;
    emit(state.copyWith(
      status: TransactionsStatus.loading,
      clearError: true,
    ));

    await emit.forEach<List<FinanceTransaction>>(
      _repository.watchTransactions(event.userId),
      onData: (transactions) => state.copyWith(
        status: TransactionsStatus.success,
        transactions: transactions,
      ),
      onError: (error, _) => state.copyWith(
        status: TransactionsStatus.failure,
        errorMessage: 'Não foi possível carregar as transações.',
      ),
    );
  }

  Future<void> _onAdded(
      TransactionAdded event,
      Emitter<TransactionState> emit,
      ) async {
    final userId = _userId;
    if (userId == null) return;

    try {
      await _repository.add(userId, event.transaction);
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Não foi possível salvar.'));
    }
  }

  Future<void> _onDeleted(
      TransactionDeleted event,
      Emitter<TransactionState> emit,
      ) async {
    final userId = _userId;
    if (userId == null) return;

    try {
      await _repository.delete(userId, event.transactionId);
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Não foi possível excluir.'));
    }
  }
}
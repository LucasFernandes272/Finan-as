import 'package:get_it/get_it.dart';

import '../../features/auth/data/firebase_auth_repository.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/transactions/data/firestore_transaction_repository.dart';
import '../../features/transactions/domain/transaction_repository.dart';
import '../../features/transactions/presentation/bloc/transaction_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<AuthRepository>(
        () => FirebaseAuthRepository(),
  );

  getIt.registerLazySingleton<AuthBloc>(
        () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<TransactionRepository>(
        () => FirestoreTransactionRepository(),
  );

  getIt.registerFactory<TransactionBloc>(
        () => TransactionBloc(repository: getIt<TransactionRepository>()),
  );
}
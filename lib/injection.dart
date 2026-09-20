import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'data/sources/remote_sources/currency_remote_source.dart';
import 'data/repositories/currency_repository_impl.dart';
import 'domain/repositories/currency_repository.dart';
import 'presentation/bloc/currency_bloc.dart';

final sl = GetIt.instance;

void init() {
  // External (Dio)
  sl.registerLazySingleton(() => Dio());

  // Data Sources
  sl.registerLazySingleton(() => CurrencyRemoteSource());

  // Repositories
  sl.registerLazySingleton<CurrencyRepository>(
        () => CurrencyRepositoryImpl(remoteSource: sl()),
  );

  // Bloc / Cubit
  sl.registerFactory(() => CurrencyBloc(dio: sl()));
}
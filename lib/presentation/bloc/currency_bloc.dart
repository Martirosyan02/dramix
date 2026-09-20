import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CurrencyEvent {}
class LoadCurrencyRates extends CurrencyEvent {}

// States
abstract class CurrencyState {}
class CurrencyInitial extends CurrencyState {}
class CurrencyLoading extends CurrencyState {}
class CurrencyLoaded extends CurrencyState {
  final Map<String, dynamic> rates;
  CurrencyLoaded(this.rates);
}
class CurrencyError extends CurrencyState {
  final String message;
  CurrencyError(this.message);
}

// BLoC
class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final Dio dio;

  CurrencyBloc({required this.dio}) : super(CurrencyInitial()) {
    on<LoadCurrencyRates>((event, emit) async {
      emit(CurrencyLoading());
      try {
        final response = await dio.get('https://api.exchangerate-api.com/v4/latest/USD');

        if (response.statusCode == 200) {
          final data = response.data;
          final rates = Map<String, dynamic>.from(data['rates']);
          emit(CurrencyLoaded(rates));
        } else {
          emit(CurrencyError('Սխալ սերվերի կողմից: ${response.statusCode}'));
        }
      } on DioException catch (e) {
        emit(CurrencyError('Ցանցային սխալ: ${e.message}'));
      } catch (e) {
        emit(CurrencyError('Անհայտ սխալ: ${e.toString()}'));
      }
    });
  }
}
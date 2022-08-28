import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_crud/model/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../boxes.dart';

part 'crud_event.dart';
part 'crud_state.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {
  CrudBloc() : super(const CrudInitial()) {
    Box<Transaction> boxTransaction;
    List<Transaction> transactions = [];
    Transaction? transaction;
    on<FetchAllData>((event, emit) {
      try {
        boxTransaction = Boxes.getTransactions();
        transactions = boxTransaction.values.toList();
        emit(DisplayAllDatas(transactions: transactions));
      } catch (e) {
        print('$e');
      }
    });

    on<AddData>((event, emit) {
      try {
        final box = Boxes.getTransactions();
        box.add(event.transaction);
        add(const FetchAllData());
      } catch (e) {
        print('$e');
      }
    });

    on<UpdateSpecificData>((event, emit) {
      try {
        transaction = event.transaction;
        transaction!.name = event.name;
        transaction!.amount = event.amount;
        transaction!.isExpense = event.isExpense;
        transaction!.save();
        add(const FetchAllData());
      } catch (e) {
        print('$e');
      }
    });

    on<DeleteSpecificData>((event, emit) {
      try {
        event.transaction.delete();
        add(const FetchAllData());
      } catch (e) {
        print('$e');
      }
    });
  }
}

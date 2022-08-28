part of 'crud_bloc.dart';

abstract class CrudState extends Equatable {
  const CrudState();

  @override
  List<Object> get props => [];
}

class CrudInitial extends CrudState {
  const CrudInitial();
  @override
  List<Object> get props => [];
}

class DisplayAllDatas extends CrudState {
  final List<Transaction> transactions;
  const DisplayAllDatas({required this.transactions});
  @override
  List<Object> get props => [transactions];
}

class DisplaySpecificData extends CrudState {
  final Transaction transaction;
  const DisplaySpecificData({required this.transaction});
  @override
  List<Object> get props => [transaction];
}

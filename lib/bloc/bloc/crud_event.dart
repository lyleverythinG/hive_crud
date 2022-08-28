part of 'crud_bloc.dart';

abstract class CrudEvent extends Equatable {
  const CrudEvent();

  @override
  List<Object> get props => [];
}

class FetchAllData extends CrudEvent {
  const FetchAllData();
  @override
  List<Object> get props => [];
}

class FetchSpecificData extends CrudEvent {
  const FetchSpecificData();
  @override
  List<Object> get props => [];
}

class AddData extends CrudEvent {
  final Transaction transaction;
  const AddData({required this.transaction});
  @override
  List<Object> get props => [transaction];
}

class DeleteSpecificData extends CrudEvent {
  final Transaction transaction;
  const DeleteSpecificData({required this.transaction});
  @override
  List<Object> get props => [transaction];
}

class UpdateSpecificData extends CrudEvent {
  final Transaction transaction;
  final String name;
  final double amount;
  final bool isExpense;
  const UpdateSpecificData(
      {required this.name,
      required this.amount,
      required this.transaction,
      required this.isExpense});
  @override
  List<Object> get props => [name, amount, transaction];
}

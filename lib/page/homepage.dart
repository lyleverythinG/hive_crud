import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_crud/bloc/bloc/crud_bloc.dart';
import '../constants/constants.dart';
import '../model/transaction.dart';
import '../widgets/custom_text.dart';
import 'detail_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  bool toggleSwitch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext cx) {
                return StatefulBuilder(
                  builder: ((context, setState) {
                    return AlertDialog(
                      title: const Text(
                        'Add',
                        style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text('Name')),
                          Flexible(
                            child: TextFormField(
                              decoration: const InputDecoration(isDense: true),
                              maxLines: 1,
                              controller: _name,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text('Amount')),
                          Flexible(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(isDense: true),
                              maxLines: 2,
                              controller: _amount,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text('Switch on if expense'),
                          Switch(
                            value: toggleSwitch,
                            onChanged: (newVal) {
                              setState(() {
                                toggleSwitch = newVal;
                              });
                            },
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          style: Constants.customButtonStyle,
                          onPressed: () {
                            _name.clear();
                            _amount.clear();
                            toggleSwitch = false;
                            Navigator.pop(cx);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: Constants.customButtonStyle,
                          onPressed: () {
                            if (_name.text.isNotEmpty &&
                                _amount.text.isNotEmpty) {
                              double amount = double.parse(_amount.text);
                              context.read<CrudBloc>().add(AddData(
                                  transaction: Transaction()
                                    ..name = _name.text
                                    ..createdDate = DateTime.now()
                                    ..amount = amount
                                    ..isExpense = toggleSwitch));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Constants.primaryColor,
                                duration: Duration(seconds: 1),
                                content: Text("added successfully"),
                              ));
                              _name.clear();
                              _amount.clear();
                              toggleSwitch = false;
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Constants.primaryColor,
                                duration: Duration(seconds: 1),
                                content:
                                    Text("name and amount can't be empty."),
                              ));
                            }
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  }),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Hive CRUD + Bloc',
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height,
        child: BlocBuilder<CrudBloc, CrudState>(
          builder: (context, state) {
            if (state is CrudInitial) {
              context.read<CrudBloc>().add(const FetchAllData());
            }
            if (state is DisplayAllDatas) {
              if (state.transactions.isNotEmpty) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.all(8),
                        itemCount: state.transactions.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => DetailsPage(
                                        transaction: state.transactions[i],
                                      )),
                                ),
                              );
                            },
                            child: Container(
                              height: 80,
                              margin: const EdgeInsets.only(bottom: 14),
                              child: Card(
                                elevation: 10,
                                color: Colors.black87,
                                child: Column(
                                  children: [
                                    ListTile(
                                      subtitle: CustomText(
                                        text: state.transactions[i].isExpense ==
                                                true
                                            ? 'expense'.toUpperCase()
                                            : 'income'.toUpperCase(),
                                      ),
                                      leading: CustomText(
                                        text: state.transactions[i].name
                                            .toUpperCase(),
                                      ),
                                      title: CustomText(
                                        text: state.transactions[i].amount
                                            .toString(),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                context.read<CrudBloc>().add(
                                                    DeleteSpecificData(
                                                        transaction: state
                                                            .transactions[i]));
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            }
            return Center(
              child: Text(
                'empty'.toUpperCase(),
                style: const TextStyle(fontSize: 21),
              ),
            );
          },
        ),
      ),
    );
  }
}

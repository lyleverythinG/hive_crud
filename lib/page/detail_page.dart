import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_crud/bloc/bloc/crud_bloc.dart';

import '../constants/constants.dart';
import '../model/transaction.dart';

class DetailsPage extends StatefulWidget {
  final Transaction transaction;
  const DetailsPage({Key? key, required this.transaction}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final TextEditingController _newName = TextEditingController();
  final TextEditingController _newAmount = TextEditingController();
  bool toggleSwitch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'name'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.transaction.name,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.transaction.isExpense
                      ? 'expense'.toUpperCase()
                      : 'income'.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.transaction.amount.toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: Constants.customButtonStyle,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext cx) {
                              return StatefulBuilder(
                                builder: ((context, setState) => AlertDialog(
                                      title: const Text(
                                        'Update',
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
                                              decoration: const InputDecoration(
                                                  isDense: true),
                                              maxLines: 1,
                                              controller: _newName,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Align(
                                              alignment: Alignment.topLeft,
                                              child: Text('Amount')),
                                          Flexible(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                  isDense: true),
                                              maxLines: 2,
                                              controller: _newAmount,
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
                                            Navigator.pop(cx);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        BlocBuilder<CrudBloc, CrudState>(
                                          builder: (context, state) {
                                            return ElevatedButton(
                                              style:
                                                  Constants.customButtonStyle,
                                              onPressed: () {
                                                double amount = double.parse(
                                                    _newAmount.text);
                                                context.read<CrudBloc>().add(
                                                      UpdateSpecificData(
                                                          transaction: widget
                                                              .transaction,
                                                          name: _newName.text,
                                                          amount: amount,
                                                          isExpense:
                                                              toggleSwitch),
                                                    );
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Update'),
                                            );
                                          },
                                        ),
                                      ],
                                    )),
                              );
                            });
                      },
                      child: Text(
                        'Update'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

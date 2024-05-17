import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymly/bloc/excercise/cubit.dart';
import 'package:gymly/bloc/filter_excercise/cubit.dart';
import 'package:gymly/bloc/workout_scheduleCRUD/cubit.dart';
import 'package:gymly/colors.dart';
import 'package:gymly/model/ExcerciseModel.dart';
import 'package:gymly/widget/customAppBar.dart';
import 'package:gymly/model/WorkoutScheduleModel.dart';
import 'package:gymly/widget/customAppBarWithBack.dart';
import 'package:intl/intl.dart';

class AddExcercise extends StatefulWidget {
  const AddExcercise({Key? key}) : super(key: key);

  @override
  State<AddExcercise> createState() => _AddExcerciseState();
}

class _AddExcerciseState extends State<AddExcercise> {
  String? _nameExcercise;
  String? _set;
  String? _rep;
  String? _recovery;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    final ExcerciseModel newExcercise = ExcerciseModel(
      idSchedule: context.read<FilterExcerciseCubit>().state.id_schedule,
      idDay: context.read<FilterExcerciseCubit>().state.selectedDays,
      idWeek: context.read<FilterExcerciseCubit>().state.selectedWeek,
      setsAndRep: '${_set}x$_rep',
      recovery: int.parse(_recovery!),
      nome: _nameExcercise!,
    );
    context.read<ExcerciseCubit>().addExcercise(newExcercise);
    Navigator.of(context).pop();
  }

  Widget formName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: "Excercise",
        floatingLabelStyle: TextStyle(color: CustomColor.fontBlack),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.orange,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Name required';
        }
        return null;
      },
      onSaved: (String? value) {
        _nameExcercise = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithBack(),
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 12),
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Form(
            key: _formKey,
            child: Column(children: [
              SizedBox(
                height: 50,
                child: formName(),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Set: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 45,
                    height: 40,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.orange,
                          ),
                        ),

                        /*COSI EVITO DI MODIFICARE HEIGHT IN CASO DI ERRORE*/
                        errorStyle: TextStyle(fontSize: 0.01),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _set = value;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    'Rep: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 45,
                    height: 40,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        filled: true,
                        focusedBorder: InputBorder.none,
                        errorStyle: TextStyle(fontSize: 0.01),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _rep = value;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Recovery: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 60,
                    height: 40,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        filled: true,
                        focusedBorder: InputBorder.none,
                        errorStyle: TextStyle(fontSize: 0.01),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _recovery = value;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'sec',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Salva'),
                style:
                    ElevatedButton.styleFrom(backgroundColor: CustomColor.orangePrimary, foregroundColor: CustomColor.fontBlack),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

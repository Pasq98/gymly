import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymly/bloc/workout_scheduleCRUD/cubit.dart';
import 'package:gymly/colors.dart';
import 'package:gymly/widget/customAppBar.dart';
import 'package:gymly/model/WorkoutScheduleModel.dart';
import 'package:intl/intl.dart';

class CreateSchedule extends StatefulWidget {
  const CreateSchedule({Key? key}) : super(key: key);

  @override
  State<CreateSchedule> createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  final TextEditingController dateControllerStart = TextEditingController();
  final TextEditingController dateControllerEnd = TextEditingController();
  DateTime? _pickedDateStart;
  DateTime? _pickedDateEnd;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _name;
  String? _dieta;
  final List<String> _tipoDieta = ['ipercalorica', 'normocalorica', 'ipocalorica'];
  final List<String> __daysForWeekItem = ['1', '2', '3', '4', '5', '6', '7'];
  String? _daysForWeek;
  int? _weeksLenght;
  var differenceWeek = 0;

  void _submit() {
    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;
    differenceWeek = (_pickedDateEnd!.difference(_pickedDateStart!).inHours / 24).round();
    if (differenceWeek <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('La data iniziale non può essere dopo quella finale')));
      return;
    }

    _weeksLenght = (differenceWeek < 7 ? 1 : differenceWeek / 7).round();
    print('Weeks lenght: $_weeksLenght');

    form.save();
    context.read<WorkoutScheduleCubit>().addSchedule(
          WorkoutScheduleModel(
              title: _name!,
              dataFine: dateControllerEnd.text,
              dataInizio: dateControllerStart.text,
              dieta: _dieta!,
              workoutDays: int.parse(_daysForWeek!),
              weeksLenght: _weeksLenght!),
        );
    Navigator.of(context).pop();
  }

  Widget formName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: "Name",
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
        _name = value;
      },
    );
  }

  Widget formDateStart() {
    return TextFormField(
      controller: dateControllerStart, //editing controller of this TextField
      decoration: const InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.calendar_today, color: CustomColor.orangePrimary), //icon of text field
        labelText: "Data inizio", //label text of field
        labelStyle: TextStyle(color: Colors.grey),
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Data inizio richiesta';
        }

        return null;
      },
      readOnly: true, // when true user cannot edit text
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            //TODO: risolvere bug initialDate. Se InizialtDate non è lunedi dà errore
            initialDate: DateTime(DateTime.now().year, DateTime.now().month, 6), //get today's date
            firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101),
            selectableDayPredicate: (DateTime val) => (val.weekday == 5 ||
                    val.weekday == 6 ||
                    val.weekday == 2 ||
                    val.weekday == 3 ||
                    val.weekday == 4 ||
                    val.weekday == 7
                ? false
                : true));

        if (pickedDate != null) {
          String formattedDate = DateFormat('dd-MMMM-yyyy')
              .format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
          print(formattedDate);

          setState(() {
            dateControllerStart.text = formattedDate; //set foratted date to TextField value.
            _pickedDateStart = pickedDate;
            print(dateControllerStart.text);
          });
        } else {
          print("Date is not selected");
        }
      },
    );
  }

  Widget formDateEnd() {
    return TextFormField(
      controller: dateControllerEnd, //editing controller of this TextField
      decoration: const InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.calendar_today, color: CustomColor.orangePrimary), //icon of text field
        labelText: "Data fine", //label text of field
        labelStyle: TextStyle(color: Colors.grey),
      ),
      readOnly: true, // when true user cannot edit text
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Data fine richiesta';
        }
        return null;
      },
      onTap: () async {
        //TODO: aggiungere il controllo sopra (se monday diverso dal primo giorno del mese)
        DateTime? pickedDateEnd = await showDatePicker(
            context: context,
            initialDate: DateTime(DateTime.now().year, DateTime.now().month, 6), //get today's date
            firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101),
            selectableDayPredicate: (DateTime val) => (val.weekday == 5 ||
                    val.weekday == 6 ||
                    val.weekday == 2 ||
                    val.weekday == 3 ||
                    val.weekday == 4 ||
                    val.weekday == 7
                ? false
                : true));

        if (pickedDateEnd != null) {
          String formattedDate = DateFormat('dd-MMMM-yyyy')
              .format(pickedDateEnd); // format date in required form here we use yyyy-MM-dd that means time is removed
          print(formattedDate);

          setState(() {
            dateControllerEnd.text = formattedDate;
            _pickedDateEnd = pickedDateEnd;
          });
        } else {
          print("Date is not selected");
        }
      },
    );
  }

  @override
  void dispose() {
    dateControllerStart.dispose();
    dateControllerEnd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_outlined),
            iconSize: 28,
            color: CustomColor.fontBlack),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.logout), iconSize: 28, color: CustomColor.fontBlack),
        ],
        title: const Center(
          child: Text(
              style: TextStyle(
                  color: CustomColor.fontBlack,
                  shadows: [
                    Shadow(
                      color: Colors.grey, // Choose the color of the shadow
                    ),
                  ],
                  fontWeight: FontWeight.w600,
                  fontSize: 28),
              'GIMLY'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 12),
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Form(
            key: _formKey,
            child: Column(children: [
              formName(),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                width: 10,
              ),
              formDateStart(),
              formDateEnd(),
              Row(
                children: [
                  const SizedBox(
                    width: 80,
                  ),
                  const Flexible(
                    flex: 2,
                    child: Text(
                      'Dieta: ',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 3,
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(enabledBorder: InputBorder.none, border: InputBorder.none),
                      value: _dieta,
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Seleziona il tipo di dieta';
                        }
                        return null;
                      },
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          _dieta = value!;
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          _dieta = value!;
                        });
                      },
                      items: _tipoDieta.map((String val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Center(
                            child: Text(
                              val,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 80,
                  ),
                  const Flexible(
                    flex: 3,
                    child: Text(
                      'Days for week: ',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 1,
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(enabledBorder: InputBorder.none, border: InputBorder.none),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Seleziona il numero di giorni';
                        }
                        return null;
                      },
                      value: _daysForWeek,
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          _daysForWeek = value!;
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          _daysForWeek = value!;
                        });
                      },
                      items: __daysForWeekItem.map((String val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Center(
                            child: Text(
                              val,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
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

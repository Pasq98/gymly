import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymly/bloc/reps/cubit.dart';
import 'package:gymly/bloc/reps/state.dart';
import 'package:gymly/colors.dart';
import 'package:gymly/model/ExcerciseModel.dart';
import 'package:gymly/model/RepModel.dart';
import 'package:gymly/pages/ViewExcercise/titleExcercise.dart';
import 'package:logger/logger.dart';

class ExcerciseItem extends StatefulWidget {
  final ExcerciseModel excercise;
  ExcerciseItem({Key? key, required this.excercise}) : super(key: key);

  @override
  State<ExcerciseItem> createState() => _ExcerciseItemState();
}

class _ExcerciseItemState extends State<ExcerciseItem> {
  bool isCedimento = true;
  Map<int, bool> switchValue = {};
  int nOfSet = 0;
  var logger = Logger();

  @override
  void initState() {
    context.read<SetsAndRepCubit>().getRep(widget.excercise);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    nOfSet = int.parse(widget.excercise.setsAndRep.substring(0, 1));

    for (int i = 0; i < nOfSet; i++) {
      Map<int, bool> map = {i: false};
      switchValue.addEntries(map.entries);
    }

    return BlocConsumer<SetsAndRepCubit, SetAndRepState>(listener: (context, state) {
      // TODO: implement listener
    }, builder: (context, state) {
      if (state.repStatus == RepEnumState.retrieved) {
        //print(widget.excercise);
        logger.d(state.listRep);
        logger.d('Widget exer id: ${widget.excercise.id}');
        List<RepModel> currentRepModel = state.listRep.where((element) => widget.excercise.id == element.idExcercise).toList();
        logger.d(currentRepModel);

        print(state.repStatus);
        return Column(
          children: [
            TitleExcercise(excercise: widget.excercise),
            Container(
              // height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                      // border:
                      //   TableBorder(horizontalInside: BorderSide(width: 20, color: Colors.blueAccent, style: BorderStyle.solid)),
                      children: [
                        //INTESTAZIONE
                        TableRow(children: [
                          SizedBox(
                            height: 22,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 2),
                            child: Text(
                              'REP',
                              style: TextStyle(fontWeight: FontWeight.w400, color: CustomColor.fontBlack.withOpacity(0.6)),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 18),
                            child: Text(
                              'KG',
                              style: TextStyle(fontWeight: FontWeight.w400, color: CustomColor.fontBlack.withOpacity(0.6)),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 25),
                            child: Text(
                              'CED',
                              style: TextStyle(fontWeight: FontWeight.w400, color: CustomColor.fontBlack.withOpacity(0.6)),
                            ),
                          ),
                        ]),

                        for (int currentSet = 0; currentSet < nOfSet; currentSet++)
                          TableRow(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 6),
                                child: Text(
                                  'SET ${currentSet + 1}',
                                  style: TextStyle(fontWeight: FontWeight.w400, color: CustomColor.fontBlack.withOpacity(0.6)),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 0, right: 40, bottom: 8),
                                  height: 30,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                  )),
                              Container(
                                margin: const EdgeInsets.only(left: 0, right: 28),
                                height: 30,
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintText: '',
                                    //state.repStatus == RepEnumState.retrieved
                                    //     ? currentRepModel[currentSet].peso.toString()
                                    //  : '',
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    context
                                        .read<SetsAndRepCubit>()
                                        .addPesoToRep(int.parse(value), currentSet + 1, widget.excercise);

                                    //context.read<SetsAndRepCubit>().getRep(widget.excercise);
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 0, right: 0),
                                height: 30,
                                child: Switch(
                                  //TODO: aggiustare colore
                                  activeColor: Colors.yellow.withOpacity(0.2),
                                  splashRadius: 50.0,
                                  value: switchValue[currentSet]!,
                                  onChanged: (value) {
                                    setState(() {
                                      switchValue[currentSet] = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                      ]),
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            )
          ],
        );
      } else {
        return SizedBox(height: 250, width: 250, child: CircularProgressIndicator());
      }
    });
  }
}

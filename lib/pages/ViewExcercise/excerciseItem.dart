import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymly/bloc/excercise/cubit.dart';

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
    for (int i = 0; i < nOfSet; i++) {
      Map<int, bool> map = {i: false};
      switchValue.addEntries(map.entries);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    nOfSet = int.parse(widget.excercise.setsAndRep.substring(0, 1));

    logger.d(widget.excercise);

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
                                textAlignVertical: TextAlignVertical.bottom,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: widget.excercise.reps![currentSet].rep.toString(),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                                onSubmitted: (rep) {
                                  context.read<ExcerciseCubit>().addRepToSet(int.parse(rep), currentSet + 1, widget.excercise);
                                },
                              )),
                          Container(
                            margin: const EdgeInsets.only(left: 0, right: 28),
                            height: 30,
                            child: TextField(
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.bottom,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: widget.excercise.reps![currentSet].peso.toString(),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                              onSubmitted: (peso) {
                                context.read<ExcerciseCubit>().addPesoToRep(int.parse(peso), currentSet + 1, widget.excercise);
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 0, right: 0),
                            height: 30,
                            child: Switch(
                              activeColor: Color.fromRGBO(255, 217, 125, 1),
                              splashRadius: 50.0,
                              value: widget.excercise.reps![currentSet].ced == 1 ? true : false,
                              onChanged: (value) {
                                setState(() {
                                  context
                                      .read<ExcerciseCubit>()
                                      .switchCed(widget.excercise.reps![currentSet].idSet, widget.excercise);
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
  }
}

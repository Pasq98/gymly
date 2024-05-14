import 'package:flutter/material.dart';
import 'package:gymly/colors.dart';
import 'package:gymly/model/ExcerciseModel.dart';

class TitleExcercise extends StatelessWidget {
  final ExcerciseModel excercise;

  const TitleExcercise({Key? key, required this.excercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 2,
      ),
      height: 45,
      width: MediaQuery.of(context).size.width * 0.9,
      // color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                excercise.setsAndRep,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomColor.fontBlack),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                excercise.nome,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomColor.fontBlack),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                excercise.recovery.toString() + '"',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomColor.fontBlack),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

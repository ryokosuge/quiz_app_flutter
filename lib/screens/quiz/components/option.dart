import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:quiz_app_flutter/controllers/question_controller.dart';

import '../../../constants.dart';

class Option extends StatelessWidget {
  final String text;
  final int index;
  final VoidCallback onPressed;

  const Option({
    Key? key,
    required this.text,
    required this.index,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
      init: QuestionController(),
      builder: (questionController) {
        Color getTheRightColor() {
          if (questionController.isAnswered) {
            if (index == questionController.correctAns) {
              return kGreenColor;
            } else if (index == questionController.selectedAns &&
                questionController.selectedAns !=
                    questionController.correctAns) {
              return kRedColor;
            }
          }
          return kGrayColor;
        }

        IconData getTheRightIcon() {
          return getTheRightColor() == kRedColor ? Icons.close : Icons.done;
        }

        return InkWell(
          onTap: onPressed,
          child: Container(
            margin: EdgeInsets.only(top: kDefaultPadding),
            padding: EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
              border: Border.all(color: getTheRightColor()),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${index + 1} $text",
                  style: TextStyle(
                    color: getTheRightColor(),
                    fontSize: 16.0,
                  ),
                ),
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                    color: getTheRightColor() == kGrayColor
                        ? Colors.transparent
                        : getTheRightColor(),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: getTheRightColor()),
                  ),
                  child: getTheRightColor() == kGrayColor
                      ? null
                      : Icon(getTheRightIcon()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

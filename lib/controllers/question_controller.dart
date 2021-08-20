import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_flutter/models/questions.dart';
import 'package:quiz_app_flutter/screens/score/score_screen.dart';

// We use get package for our state management

class QuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  // Lets animated our progress bar

  AnimationController? _animationController;
  Animation<double>? _animation;
  // so that we can access our animation outside
  Animation? get animation => _animation;

  PageController? _pageController;
  PageController? get pageController => _pageController;

  List<Question> _questions = sample_data
      .map(
        (question) => Question(
            id: question['id'],
            question: question['question'],
            answer: question['answer_index'],
            options: question['options']),
      )
      .toList();

  List<Question> get questions => _questions;

  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  int _correctAns = 0;
  int get correctAns => _correctAns;

  int? _selectedAns;
  int? get selectedAns => _selectedAns;

  // for more about obs please check documentation
  RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => _numOfCorrectAns;

  void checkAns(Question question, int selectedIndex) {
    // because once user press any option then it will run
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) _numOfCorrectAns++;

    // It will stop the counter
    _animationController?.stop();
    update();

    // Once user select an answer after 3s it will go to the next question.
    Future.delayed(Duration(seconds: 3), () {
      nextQuestion();
    });
  }

  // called immediately after the widget is allocated memory
  @override
  void onInit() {
    // Our animation duration is 60s
    // so our plan is to fill the progress bar
    final animationController = AnimationController(
      duration: Duration(seconds: 60),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(animationController)
      ..addListener(() {
        // update like setState
        update();
      });
    _animationController = animationController;
    // start our animation
    _animationController?.forward().whenComplete(nextQuestion);
    _pageController = PageController();

    super.onInit();
  }

  @override
  void onClose() {
    _animationController?.dispose();
    _pageController?.dispose();
    super.onClose();
  }

  void nextQuestion() {
    if (_questionNumber.value != _questions.length) {
      _isAnswered = false;
      _pageController?.nextPage(
        duration: Duration(milliseconds: 250),
        curve: Curves.ease,
      );
      _animationController?.reset();

      // Then start it again
      // Once timer is finish go to the next question
      _animationController?.forward().whenComplete(nextQuestion);
    } else {
      Get.to(() => ScoreScreen());
    }
  }

  void updateTheQuestionNum(int index) {
    _questionNumber.value = index + 1;
  }
}

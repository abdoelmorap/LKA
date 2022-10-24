import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/controller/user_controller.dart';
import 'package:infixedu/screens/student/onlineExam/module/controller/ExamController.dart';
import 'package:infixedu/screens/student/onlineExam/module/model/TakeExamModel.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:http/http.dart' as http;

class OnlineExamController extends GetxController
    with GetTickerProviderStateMixin {
  final UserController userController = Get.put(UserController());

  final ExamController _examController = Get.put(ExamController());

  RxBool isQuizStarting = false.obs;

  RxBool finalSubmitExam = false.obs;

  RxBool quizResultLoading = false.obs;

  RxInt _questionNumber = 1.obs;

  RxInt get questionNumber => this._questionNumber;

  var quiz = TakeExamModel().obs;

  var questions = <ExamQuestion>[].obs;

  var checkSelectedIndex = 0.obs;
  RxBool lastQuestion = false.obs;

  var color = Colors.white.obs;

  var currentQuestion = ExamQuestion().obs;

  PageController _pageController;

  PageController get pageController => this._pageController;

  AnimationController _animationController;

  Animation _animation;

  Animation get animation => this._animation;

  RxList<bool> answered = <bool>[].obs;

  RxBool submitSingleAnswer = false.obs;

  var types = [].obs;

  var questionTime = 1.obs;

  bool checkSelected(index) {
    return currentQuestion.value == quiz.value.examQuestions[index]
        ? true
        : false;
  }

  void startController(TakeExamModel quizParam) {
    questionNumber.value = 1;
    answered.clear();
    types.clear();
    quiz.value = quizParam;

    if (_questionNumber.value == quiz.value.examQuestions.length) {
      lastQuestion.value = true;
    } else {
      lastQuestion.value = false;
    }

    if (quiz.value.onlineExam.durationType == "question") {
      questionTime.value = quiz.value.onlineExam.defaultQuestionTime;
    } else {
      questionTime.value = quiz.value.onlineExam.duration;
    }

    if (quiz.value.onlineExamSetting.randomQuestion == 1) {
      // Randomize Question
      questions.value = quiz.value.examQuestions..shuffle();
    } else {
      questions.value = quiz.value.examQuestions;
    }
    questions.forEach((element) {
      answered.add(false);
      types.add(element.questionType);
    });
    print(types);
    currentQuestion.value = quiz.value.examQuestions.first;
    _animationController = AnimationController(
        duration: Duration(seconds: questionTime.value * 60), vsync: this);
    _animation = StepTween(begin: questionTime.value * 60, end: 0)
        .animate(_animationController)
      ..addListener(() {
        update();
      });
    if (quiz.value.onlineExam.durationType == "question") {
      print("QUESTION TYPE-> PER QUESTION");
      _animationController.forward().whenComplete(() {
        skipPress(0);
      });
    } else {
      print("QUESTION TYPE-> EXAM");
      _animationController.forward().whenComplete(finalSubmit);
    }

    _pageController = PageController();
  }

  Future finalSubmit() async {
    print("finalise");

    print("completeddd");

    Map data = {
      'student_id': userController.studentId.value,
      'online_exam_id': quiz.value.onlineExam.id,
      'student_record_id': userController.selectedRecord.value.id,
    };
    _animationController.stop();
    try {
      finalSubmitExam(true);
      var returnValue = false;

      final response = await http.post(
        Uri.parse(InfixApi.studentSubmitAnswerFinal),
        headers: Utils.setHeader(userController.token.toString()),
        body: jsonEncode(data),
      );
      print(response.body);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        finalSubmitExam(false);
        print(jsonData);

        var id;

        Utils.getStringValue('id').then((value) async {
          id = id != null ? id : value;
          await _examController.getAllActiveExam(
              id, userController.selectedRecord.value.id);
        });

        Get.back();
      } else {
        finalSubmitExam(false);
        throw Exception('Failed to load');
      }

      return returnValue;
    } finally {
      finalSubmitExam(false);
    }
  }

  void updateTheQnNum(int index) {
    currentQuestion.value = quiz.value.examQuestions[index];
    checkSelected(index);
    _questionNumber.value = index + 1;
    if (_questionNumber.value == quiz.value.examQuestions.length) {
      lastQuestion.value = true;
    } else {
      lastQuestion.value = false;
    }
  }

  void questionSelect(index) {
    print("questionSelect $index");
    currentQuestion.value = quiz.value.examQuestions[index];

    _pageController.animateToPage(index,
        curve: Curves.easeInOut, duration: Duration(milliseconds: 200));
    if (quiz.value.onlineExam.durationType == "question") {
      _animationController.reset();
      _animationController.forward().whenComplete(() {
        skipPress(index);
      });
    } else {
      print("ONE Q TYPE => ${quiz.value.onlineExam.durationType}");
    }
  }

  Future skipPress(index) async {
    print(
        "NExt => ${_questionNumber.value} ----- ${quiz.value.examQuestions.length}");
    if (_questionNumber.value != quiz.value.examQuestions.length) {
      currentQuestion.value = quiz.value.examQuestions[index + 1];
      _pageController.nextPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      if (quiz.value.onlineExam.durationType == "question") {
        _animationController.forward().whenComplete(() {
          skipPress(index);
        });
      }
    } else {
      // await questionResultPreview(quizController.quizStart.value.data.id, true)
      //     .then((value) {
      //   _animationController.stop();
      //   // Get.back();
      //   // Get.to(() => QuizResultScreen());
      //   Get.to(() => MyQuizResultSummary());
      // });
    }
  }

  Future<bool> singleSubmit(int index, Map data, bool isMultiple) async {
    submitSingleAnswer(true);
    log(jsonEncode(data).toString());
    try {
      var returnValue = false;

      final response = await http.post(
        Uri.parse(isMultiple
            ? InfixApi.studentSubmitAnswerMulti
            : InfixApi.studentSubmitAnswerSubjective),
        headers: Utils.setHeader(userController.token.toString()),
        body: jsonEncode(data),
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        answered[index] = true;
        var jsonData = jsonDecode(response.body);
        submitSingleAnswer(false);
        print(jsonData);
      } else {
        submitSingleAnswer(false);
        throw Exception('Failed to load');
      }

      return returnValue;
    } finally {
      submitSingleAnswer(false);
    }
  }

  Future startQuiz(examId, recordId, String schoolId) async {
    try {
      isQuizStarting(true);
      final response = await http.get(
          Uri.parse(InfixApi.takeOnlineExamModule(
              examId, recordId, int.parse(schoolId))),
          headers: Utils.setHeader(userController.token.value.toString()));
      if (response.statusCode == 200) {
        isQuizStarting(false);

        log(response.body.toString());

        final jsonString = jsonDecode(response.body);

        return TakeExamModel.fromJson(jsonString);
      } else {
        isQuizStarting(false);
        throw Exception('Failed to load');
      }
    } catch (e) {
      isQuizStarting(false);
      print(e);
    }
  }

  @override
  void onClose() {
    super.onClose();
    _animationController.dispose();
    _pageController.dispose();
  }
}

class CheckboxModal {
  String title;
  String alphabet;
  String image;
  String imageTitle;
  bool value;
  int id;

  CheckboxModal({
    this.title,
    this.value,
    this.image,
    this.imageTitle,
    this.id,
    this.alphabet,
  });
}

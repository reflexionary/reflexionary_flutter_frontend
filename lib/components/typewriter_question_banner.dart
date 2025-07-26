import 'dart:async';
import 'package:flutter/material.dart';

class TypewriterQuestionBanner extends StatefulWidget {
  const TypewriterQuestionBanner({super.key});

  @override
  State<TypewriterQuestionBanner> createState() => _TypewriterQuestionBannerState();
}

class _TypewriterQuestionBannerState extends State<TypewriterQuestionBanner> {
  final List<String> questions = [
    "How often did you check the charts — and why?",
    "How did you feel while trading?",
    "What pattern did you repeat — knowingly or unknowingly?",
    "Did you follow your trading plan?",
    "What insight surprised you most?",
    "If today’s trades were reviewed by your future self, what would they critique?"
  ];

  int currentQuestionIndex = 0;
  String visibleText = '';
  bool isDeleting = false;
  Timer? timer;

  Duration charDelay = const Duration(milliseconds: 50);
  Duration wordPause = const Duration(milliseconds: 1400);

  @override
  void initState() {
    super.initState();
    startTyping();
  }

  void startTyping() {
    timer = Timer.periodic(charDelay, (Timer t) {
      final currentQuestion = questions[currentQuestionIndex];

      if (!isDeleting) {
        // Typing forward
        if (visibleText.length < currentQuestion.length) {
          setState(() {
            visibleText = currentQuestion.substring(0, visibleText.length + 1);
          });
        } else {
          // Pause before deleting
          Future.delayed(wordPause, () {
            setState(() => isDeleting = true);
          });
        }
      } else {
        // Deleting backward
        if (visibleText.isNotEmpty) {
          setState(() {
            visibleText = visibleText.substring(0, visibleText.length - 1);
          });
        } else {
          // Move to next question
          setState(() {
            isDeleting = false;
            currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 35,
      left: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          visibleText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontFamily: 'Casanova',
          ),
        ),
      ),
    );
  }
}

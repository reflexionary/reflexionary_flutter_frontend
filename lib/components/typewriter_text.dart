import 'dart:async';
import 'package:flutter/material.dart';

/// A widget that displays text with a typewriter-style animation.
class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration charDelay;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.charDelay = const Duration(milliseconds: 30),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _visibleText = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the text changes, restart the animation.
    if (widget.text != oldWidget.text) {
      _timer?.cancel();
      _visibleText = '';
      _startTyping();
    }
  }

  void _startTyping() {
    if (widget.text.isEmpty) return;

    int currentIndex = 0;
    _timer = Timer.periodic(widget.charDelay, (timer) {
      if (currentIndex < widget.text.length) {
        currentIndex++;
        setState(() => _visibleText = widget.text.substring(0, currentIndex));
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Add a blinking cursor for better visual feedback while typing.
    final textToShow = '$_visibleText${_timer?.isActive ?? false ? '▋' : ''}';
    return Text(textToShow, style: widget.style);
  }
}
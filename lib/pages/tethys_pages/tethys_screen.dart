import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/components/lottie_mirror_animation.dart';

class TethysScreen extends StatefulWidget {
  const TethysScreen({super.key});

  @override
  State<TethysScreen> createState() => _TethysScreenState();
}

class _TethysScreenState extends State<TethysScreen> {
  final TextEditingController _promptController = TextEditingController();
  bool _isThinking = false;

  void _startThinking() {
    if (_promptController.text.trim().isEmpty) {
      // Don't start if the prompt is empty
      return;
    }
    FocusScope.of(context).unfocus(); // Hide keyboard
    setState(() {
      _isThinking = true;
    });

    // Simulate a delay for "thinking" or processing a request.
    // In a real app, this would be where you await your API call.
    Timer(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          _isThinking = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tethys', style: TextStyle(fontFamily: 'Runalto')),
      ),
      body: Stack(
        children: [
          Center( // Use a Stack to overlay the animation and text
            child: Stack(
              alignment: Alignment.center,
              children: [
                // The animation is always in the widget tree, but is hidden when not "thinking".
                // This allows the animation to continue running in the background and not reset.
                Offstage(
                  offstage: !_isThinking,
                  child: const LottieMirrorAnimation(),
                ),
                // Show the prompt text only when not thinking
                if (!_isThinking)
                  const Text('Ask me anything about your reflections!'),
              ],
            ),
          ),
          _buildPromptInput(),
        ],
      ),
    );
  }

  Widget _buildPromptInput() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Material(
          elevation: 8.0,
          borderRadius: BorderRadius.circular(30.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promptController,
                  decoration: const InputDecoration(
                    hintText: 'Enter a prompt...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                  onSubmitted: (_) => _startThinking(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _startThinking,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
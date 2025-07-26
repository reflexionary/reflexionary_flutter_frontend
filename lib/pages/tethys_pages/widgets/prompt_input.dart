import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PromptInput extends StatelessWidget {
  final TextEditingController promptController;
  final bool isThinking;
  final VoidCallback onSend;
  final VoidCallback onPickImage;
  final XFile? selectedImage;
  final VoidCallback onClearImage;

  const PromptInput({
    super.key,
    required this.promptController,
    required this.isThinking,
    required this.onSend,
    required this.onPickImage,
    this.selectedImage,
    required this.onClearImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Material(
            elevation: 8.0,
            borderRadius: BorderRadius.circular(30.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: onPickImage,
                  color: Theme.of(context).colorScheme.primary,
                ),
                if (selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Chip(
                      label: Text(selectedImage!.name),
                      onDeleted: onClearImage,
                    ),
                  ),
                Expanded(
                  child: TextField(
                    controller: promptController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a prompt...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                    onSubmitted: (_) => onSend(),
                  ),
                ),
                IconButton(
                  icon: Icon(isThinking ? Icons.hourglass_empty : Icons.send),
                  onPressed: isThinking ? null : onSend,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
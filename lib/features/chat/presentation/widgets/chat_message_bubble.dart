import 'package:flutter/material.dart';

import '../../domain/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final colors = Theme.of(context).colorScheme;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isUser ? colors.primaryContainer : colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: isUser ? null : Border.all(color: colors.outlineVariant),
          ),
          child: SelectableText(
            message.text,
            style: TextStyle(
              color: isUser ? colors.onPrimaryContainer : colors.onSurface,
              height: 1.45,
            ),
          ),
        ),
      ),
    );
  }
}

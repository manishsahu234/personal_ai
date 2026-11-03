import 'package:equatable/equatable.dart';

import '../../domain/chat_message.dart';

class ChatState extends Equatable {
  const ChatState({
    this.messages = const [],
    this.selectedModel = 'No model selected',
    this.isGenerating = false,
  });

  final List<ChatMessage> messages;
  final String selectedModel;
  final bool isGenerating;

  ChatState copyWith({
    List<ChatMessage>? messages,
    String? selectedModel,
    bool? isGenerating,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      selectedModel: selectedModel ?? this.selectedModel,
      isGenerating: isGenerating ?? this.isGenerating,
    );
  }

  @override
  List<Object?> get props => [messages, selectedModel, isGenerating];
}

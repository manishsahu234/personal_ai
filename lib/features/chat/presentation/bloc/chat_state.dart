import 'package:equatable/equatable.dart';

import '../../domain/chat_message.dart';

class ChatState extends Equatable {
  const ChatState({
    this.messages = const [],
    this.selectedModel = 'No model selected',
    this.isGenerating = false,
    this.isModelLoading = false,
    this.isModelLoaded = false,
    this.modelLoadProgress = 0,
    this.errorMessage,
  });

  final List<ChatMessage> messages;
  final String selectedModel;
  final bool isGenerating;
  final bool isModelLoading;
  final bool isModelLoaded;
  final double modelLoadProgress;
  final String? errorMessage;

  ChatState copyWith({
    List<ChatMessage>? messages,
    String? selectedModel,
    bool? isGenerating,
    bool? isModelLoading,
    bool? isModelLoaded,
    double? modelLoadProgress,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      selectedModel: selectedModel ?? this.selectedModel,
      isGenerating: isGenerating ?? this.isGenerating,
      isModelLoading: isModelLoading ?? this.isModelLoading,
      isModelLoaded: isModelLoaded ?? this.isModelLoaded,
      modelLoadProgress: modelLoadProgress ?? this.modelLoadProgress,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    messages,
    selectedModel,
    isGenerating,
    isModelLoading,
    isModelLoaded,
    modelLoadProgress,
    errorMessage,
  ];
}

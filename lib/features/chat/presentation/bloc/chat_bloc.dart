import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_ai/code/device/device_memory_provider.dart';

import '../../../ai/domain/ai_chat_service.dart';
import '../../domain/chat_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this._aiChatService, {DeviceMemoryProvider? deviceMemoryProvider})
    : _deviceMemoryProvider = deviceMemoryProvider ?? DeviceMemoryService(),
      super(const ChatState()) {
    on<SendMessageRequested>(_onSendMessage);
    on<NewConversationRequested>(_onNewConversation);
    on<ModelSelectionChanged>(_onModelSelectionChanged);
    on<LoadModelRequested>(_onLoadModel);
  }

  final AiChatService _aiChatService;
  final DeviceMemoryProvider _deviceMemoryProvider;

  static const int minimumRamMb = 4096;

  Future<void> _onLoadModel(LoadModelRequested event, Emitter<ChatState> emit) async {
    if (state.isModelLoading || state.isGenerating) return;

    emit(state.copyWith(isModelLoading: true, modelLoadProgress: 0, clearError: true));

    try {
      final ramMb = await _deviceMemoryProvider.getPhysicalRamMb();

      if (ramMb != null && ramMb < minimumRamMb) {
        emit(
          state.copyWith(
            isModelLoading: false,
            errorMessage:
                'Your device has ${(ramMb / 1024).toStringAsFixed(1)} GB RAM. '
                'Personal AI requires at least 4 GB RAM to load local models.',
          ),
        );
        return;
      }

      await _aiChatService.loadModel(
        modelUri: event.modelUri,
        onProgress: (progress) {
          if (progress != null) {
            emit(state.copyWith(modelLoadProgress: progress));
          }
        },
      );

      emit(
        state.copyWith(
          selectedModel: event.modelName,
          isModelLoading: false,
          isModelLoaded: true,
          modelLoadProgress: 1,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isModelLoading: false, isModelLoaded: false, errorMessage: error.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessageRequested event, Emitter<ChatState> emit) async {
    final text = event.text.trim();

    if (text.isEmpty || state.isGenerating || state.isModelLoading) {
      return;
    }

    if (!_aiChatService.isModelLoaded) {
      emit(state.copyWith(errorMessage: 'Please load an AI model before sending a message.'));
      return;
    }

    final userMessage = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      role: MessageRole.user,
      createdAt: DateTime.now(),
    );

    final assistantId = '${DateTime.now().microsecondsSinceEpoch}_assistant';

    final assistantMessage = ChatMessage(
      id: assistantId,
      text: '',
      role: MessageRole.assistant,
      createdAt: DateTime.now(),
    );

    emit(
      state.copyWith(
        messages: [...state.messages, userMessage, assistantMessage],
        isGenerating: true,
        clearError: true,
      ),
    );

    try {
      await for (final chunk in _aiChatService.generate(text)) {
        final updatedMessages = state.messages.map((message) {
          if (message.id == assistantId) {
            return ChatMessage(
              id: assistantId,
              text: message.text + chunk,
              role: MessageRole.assistant,
              createdAt: message.createdAt,
            );
          }
          return message;
        }).toList();

        emit(state.copyWith(messages: updatedMessages));
      }

      emit(state.copyWith(isGenerating: false));
    } catch (error) {
      emit(state.copyWith(isGenerating: false, errorMessage: error.toString()));
    }
  }

  void _onNewConversation(NewConversationRequested event, Emitter<ChatState> emit) {
    emit(state.copyWith(messages: const [], clearError: true));
  }

  void _onModelSelectionChanged(ModelSelectionChanged event, Emitter<ChatState> emit) {
    emit(state.copyWith(selectedModel: event.modelName));
  }

  @override
  Future<void> close() async {
    await _aiChatService.dispose();
    await super.close();
  }
}

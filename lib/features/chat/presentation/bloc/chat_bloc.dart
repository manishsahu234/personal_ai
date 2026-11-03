import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/chat_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<SendMessageRequested>(_onSendMessage);
    on<NewConversationRequested>(_onNewConversation);
    on<ModelSelectionChanged>(_onModelSelectionChanged);
  }

  void _onSendMessage(SendMessageRequested event, Emitter<ChatState> emit) {
    final text = event.text.trim();
    if (text.isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      role: MessageRole.user,
      createdAt: DateTime.now(),
    );

    emit(state.copyWith(messages: [...state.messages, message]));
  }

  void _onNewConversation(
    NewConversationRequested event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(messages: const []));
  }

  void _onModelSelectionChanged(
    ModelSelectionChanged event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(selectedModel: event.modelName));
  }
}

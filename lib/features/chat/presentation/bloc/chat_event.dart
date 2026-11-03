import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageRequested extends ChatEvent {
  const SendMessageRequested(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

class NewConversationRequested extends ChatEvent {
  const NewConversationRequested();
}

class ModelSelectionChanged extends ChatEvent {
  const ModelSelectionChanged(this.modelName);

  final String modelName;

  @override
  List<Object?> get props => [modelName];
}

class LoadModelRequested extends ChatEvent {
  const LoadModelRequested({required this.modelUri, required this.modelName});

  final String modelUri;
  final String modelName;

  @override
  List<Object?> get props => [modelUri, modelName];
}

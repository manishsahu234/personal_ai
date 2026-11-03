import 'package:equatable/equatable.dart';

enum MessageRole { user, assistant }

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.role,
    required this.createdAt,
  });

  final String id;
  final String text;
  final MessageRole role;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, text, role, createdAt];
}

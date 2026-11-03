import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_ai/features/ai/domain/llama_chat_service.dart';

import 'app.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(BlocProvider(create: (_) => ChatBloc(LlamaChatService()), child: const PersonalAiApp()));
}

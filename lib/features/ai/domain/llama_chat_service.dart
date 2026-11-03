import 'package:llamadart/llamadart.dart';

import '../domain/ai_chat_service.dart';

class LlamaChatService implements AiChatService {
  LlamaEngine? _engine;
  ChatSession? _session;
  @override
  bool get isModelLoaded => _session != null;

  @override
  Future<void> loadModel({required String modelUri, void Function(double? progress)? onProgress}) async {
    await dispose();

    final engine = await LlamaEngine.load(
      LlamaModel(ModelSource.parse(modelUri)),
      params: const ModelParams(contextSize: 2048, gpuLayers: 0),
      onProgress: (progress) {
        onProgress?.call(progress.fraction);
      },
    );

    _engine = engine;

    _session = ChatSession(engine, systemPrompt: 'You are a helpful personal AI assistant.');
  }

  @override
  Stream<String> generate(String prompt) async* {
    final session = _session;

    if (session == null) {
      throw StateError('No AI model is loaded.');
    }

    await for (final chunk in session.create([
      LlamaTextContent(prompt),
    ], params: const GenerationParams(maxTokens: 256, temp: 0.7))) {
      if (chunk.text.isNotEmpty) {
        yield chunk.text;
      }
    }
  }

  @override
  Future<void> dispose() async {
    final engine = _engine;

    _engine = null;
    _session = null;

    if (engine != null) {
      await engine.dispose();
    }
  }
}

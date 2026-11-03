abstract interface class AiChatService {
  bool get isModelLoaded;

  Future<void> loadModel({required String modelUri, void Function(double? progress)? onProgress});

  Stream<String> generate(String prompt);

  Future<void> dispose();
}

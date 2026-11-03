import 'package:llamadart/llamadart.dart';

import '../domain/model_info.dart';

class ModelManagerRepository {
  ModelManagerRepository({ModelDownloadManager? manager})
    : _manager = manager ?? DefaultModelDownloadManager();

  final ModelDownloadManager _manager;

  ModelDownloadController? _activeController;

  Future<List<ModelCacheEntry>> getInstalledModels() {
    return _manager.list();
  }

  Future<ModelCacheEntry> download(
    ModelInfo model, {
    required void Function(ModelDownloadTaskSnapshot snapshot) onProgress,
  }) async {
    final controller = ModelDownloadController(manager: _manager);

    _activeController = controller;

    final subscription = controller.snapshots.listen(onProgress);

    try {
      return await controller.start(
        ModelSource.parse(model.source),
        options: ModelLoadOptions(resume: true, maxRetries: 3),
      );
    } finally {
      await subscription.cancel();
      await controller.dispose();
      _activeController = null;
    }
  }

  void cancelDownload() {
    _activeController?.cancel();
  }

  Future<void> deleteModel(String cacheKey) {
    return _manager.remove(cacheKey);
  }
}

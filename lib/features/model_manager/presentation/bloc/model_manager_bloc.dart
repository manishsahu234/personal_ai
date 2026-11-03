import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_ai/code/device/device_memory_provider.dart';

import '../../data/model_manager_repository.dart';
import '../../domain/model_info.dart';
import 'model_manager_event.dart';
import 'model_manager_state.dart';

class ModelManagerBloc extends Bloc<ModelManagerEvent, ModelManagerState> {
  ModelManagerBloc(this._repository, {DeviceMemoryProvider? deviceMemoryProvider})
    : _deviceMemoryProvider = deviceMemoryProvider ?? DeviceMemoryService(),
      super(const ModelManagerState()) {
    on<ModelLibraryOpened>(_onLibraryOpened);
    on<ModelDownloadRequested>(_onDownloadRequested);
    on<ModelDownloadCancelled>(_onDownloadCancelled);
  }

  final ModelManagerRepository _repository;
  final DeviceMemoryProvider _deviceMemoryProvider;

  Future<void> _onLibraryOpened(ModelLibraryOpened event, Emitter<ModelManagerState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final models = await _repository.getInstalledModels();

      emit(state.copyWith(installedModels: models, isLoading: false));
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  Future<void> _onDownloadRequested(ModelDownloadRequested event, Emitter<ModelManagerState> emit) async {
    if (state.isDownloading) return;

    ModelInfo model;

    try {
      model = availableModels.firstWhere((item) => item.id == event.modelId);
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Selected model was not found.'));
      return;
    }

    emit(
      state.copyWith(
        isDownloading: true,
        downloadingModelId: model.id,
        downloadProgress: 0,
        downloadStage: 'Starting download',
        clearError: true,
        clearDownload: false,
      ),
    );
    final availableStorageMb = await _deviceMemoryProvider.getAvailableStorageMb();

    const storageReserveMb = 512;

    final requiredStorageMb = model.estimatedDownloadSizeMb + storageReserveMb;

    if (availableStorageMb != null && availableStorageMb < requiredStorageMb) {
      emit(
        state.copyWith(
          isDownloading: false,
          errorMessage:
              'Not enough free storage. '
              'Required: approximately $requiredStorageMb MB. '
              'Available: $availableStorageMb MB.',
        ),
      );
      return;
    }

    try {
      await _repository.download(
        model,
        onProgress: (snapshot) {
          if (emit.isDone) return;

          emit(
            state.copyWith(
              isDownloading: snapshot.isRunning,
              downloadingModelId: snapshot.isRunning ? model.id : null,
              downloadProgress: snapshot.fraction,
              downloadStage: snapshot.stage.name,
            ),
          );
        },
      );

      final installed = await _repository.getInstalledModels();

      emit(
        state.copyWith(
          installedModels: installed,
          isDownloading: false,
          downloadStage: 'Download complete',
          downloadProgress: 1,
          clearDownload: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isDownloading: false,
          errorMessage: error.toString(),
          downloadStage: 'Download failed',
          clearDownload: true,
        ),
      );
    }
  }

  void _onDownloadCancelled(ModelDownloadCancelled event, Emitter<ModelManagerState> emit) {
    _repository.cancelDownload();
  }

  @override
  Future<void> close() async {
    _repository.cancelDownload();
    await super.close();
  }
}

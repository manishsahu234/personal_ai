import 'package:equatable/equatable.dart';
import 'package:llamadart/llamadart.dart';

class ModelManagerState extends Equatable {
  const ModelManagerState({
    this.installedModels = const [],
    this.isLoading = false,
    this.isDownloading = false,
    this.downloadingModelId,
    this.downloadProgress,
    this.downloadStage,
    this.errorMessage,
  });

  final List<ModelCacheEntry> installedModels;
  final bool isLoading;
  final bool isDownloading;
  final String? downloadingModelId;
  final double? downloadProgress;
  final String? downloadStage;
  final String? errorMessage;

  ModelManagerState copyWith({
    List<ModelCacheEntry>? installedModels,
    bool? isLoading,
    bool? isDownloading,
    String? downloadingModelId,
    double? downloadProgress,
    String? downloadStage,
    String? errorMessage,
    bool clearError = false,
    bool clearDownload = false,
  }) {
    return ModelManagerState(
      installedModels: installedModels ?? this.installedModels,
      isLoading: isLoading ?? this.isLoading,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadingModelId: clearDownload ? null : downloadingModelId ?? this.downloadingModelId,
      downloadProgress: clearDownload ? null : downloadProgress ?? this.downloadProgress,
      downloadStage: clearDownload ? null : downloadStage ?? this.downloadStage,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    installedModels,
    isLoading,
    isDownloading,
    downloadingModelId,
    downloadProgress,
    downloadStage,
    errorMessage,
  ];
}

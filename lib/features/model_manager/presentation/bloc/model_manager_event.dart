import 'package:equatable/equatable.dart';

abstract class ModelManagerEvent extends Equatable {
  const ModelManagerEvent();

  @override
  List<Object?> get props => [];
}

class ModelLibraryOpened extends ModelManagerEvent {
  const ModelLibraryOpened();
}

class ModelDownloadRequested extends ModelManagerEvent {
  const ModelDownloadRequested(this.modelId);

  final String modelId;

  @override
  List<Object?> get props => [modelId];
}

class ModelDownloadCancelled extends ModelManagerEvent {
  const ModelDownloadCancelled();
}

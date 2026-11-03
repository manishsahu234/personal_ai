import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:llamadart/llamadart.dart';

import '../../../chat/presentation/bloc/chat_bloc.dart';
import '../../../chat/presentation/bloc/chat_event.dart';
import '../../../chat/presentation/bloc/chat_state.dart';
import '../../data/model_manager_repository.dart';
import '../../domain/model_info.dart';
import '../bloc/model_manager_bloc.dart';
import '../bloc/model_manager_event.dart';
import '../bloc/model_manager_state.dart';

class ModelLibraryPage extends StatelessWidget {
  const ModelLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ModelManagerBloc(ModelManagerRepository())..add(const ModelLibraryOpened()),
      child: const _ModelLibraryView(),
    );
  }
}

class _ModelLibraryView extends StatelessWidget {
  const _ModelLibraryView();

  ModelCacheEntry? _findInstalledModel(List<ModelCacheEntry> installed, ModelInfo model) {
    for (final entry in installed) {
      if (entry.fileName == model.fileName) {
        return entry;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, chatState) {
        if (chatState.isModelLoaded && !chatState.isModelLoading) {
          Navigator.of(context).pop();
        } else if (chatState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(chatState.errorMessage!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Model Library')),
        body: BlocBuilder<ModelManagerBloc, ModelManagerState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Download a model to start chatting privately '
                  'on your device.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                if (state.errorMessage != null)
                  Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(padding: const EdgeInsets.all(12), child: Text(state.errorMessage!)),
                  ),
                for (final model in availableModels) _buildModelCard(context, state, model),
                const SizedBox(height: 20),
                const Text(
                  'Downloads run while the app is open. '
                  'Keep your device connected to Wi-Fi.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildModelCard(BuildContext context, ModelManagerState state, ModelInfo model) {
    final installed = _findInstalledModel(state.installedModels, model);

    final isDownloading = state.downloadingModelId == model.id && state.isDownloading;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.memory, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(model.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ),
                if (installed != null) const Chip(label: Text('Downloaded')),
              ],
            ),
            const SizedBox(height: 10),
            Text(model.description),
            const SizedBox(height: 12),
            Text('Format: GGUF · Q4_K_M'),
            Text('Download size: ${model.size}'),
            Text('Target device RAM: ${model.minimumRam}+'),
            const SizedBox(height: 16),
            if (isDownloading) ...[
              LinearProgressIndicator(value: state.downloadProgress),
              const SizedBox(height: 8),
              Text(
                state.downloadProgress == null
                    ? 'Downloading...'
                    : '${(state.downloadProgress! * 100).toStringAsFixed(1)}%',
              ),
              Text(state.downloadStage ?? 'Downloading', style: Theme.of(context).textTheme.bodySmall),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    context.read<ModelManagerBloc>().add(const ModelDownloadCancelled());
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('Cancel'),
                ),
              ),
            ] else if (installed != null) ...[
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, chatState) {
                  return SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: chatState.isModelLoading
                          ? null
                          : () {
                              context.read<ChatBloc>().add(
                                LoadModelRequested(modelUri: installed.filePath, modelName: model.name),
                              );
                            },
                      icon: chatState.isModelLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.play_arrow),
                      label: Text(chatState.isModelLoading ? 'Loading model...' : 'Load model'),
                    ),
                  );
                },
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: state.isDownloading
                      ? null
                      : () {
                          context.read<ModelManagerBloc>().add(ModelDownloadRequested(model.id));
                        },
                  icon: const Icon(Icons.download),
                  label: const Text('Download model'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

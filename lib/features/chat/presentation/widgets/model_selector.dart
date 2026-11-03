import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';

class ModelSelector extends StatelessWidget {
  const ModelSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (sheetContext) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose an AI model',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Model downloads and compatibility checks arrive in Phase 3.',
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.memory),
                  title: const Text('No model installed'),
                  subtitle: const Text('Open Model Library in a future phase'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.read<ChatBloc>().add(
                      const ModelSelectionChanged('No model selected'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      icon: const Icon(Icons.memory, size: 18),
      label: const Text('Select model'),
    );
  }
}

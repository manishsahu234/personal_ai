import 'package:flutter/material.dart';

import '../../../model_manager/presentation/pages/model_library_page.dart';

class ModelSelector extends StatelessWidget {
  const ModelSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ModelLibraryPage()));
      },
      icon: const Icon(Icons.memory, size: 18),
      label: const Text('Select model'),
    );
  }
}

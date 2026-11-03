class ModelInfo {
  const ModelInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.source,
    required this.fileName,
    required this.size,
    required this.minimumRam,
    required this.estimatedDownloadSizeMb,
  });

  final String id;
  final String name;
  final String description;
  final String source;
  final String fileName;
  final String size;
  final String minimumRam;
  final int estimatedDownloadSizeMb;
}

const availableModels = <ModelInfo>[
  ModelInfo(
    id: 'smollm2-360m-q4',
    name: 'SmolLM2 360M Instruct',
    description: 'Small instruction-following model for local chat.',
    source:
        'hf://bartowski/SmolLM2-360M-Instruct-GGUF/'
        'SmolLM2-360M-Instruct-Q4_K_M.gguf',
    fileName: 'SmolLM2-360M-Instruct-Q4_K_M.gguf',
    size: '~270 MB',
    minimumRam: '4 GB',
    estimatedDownloadSizeMb: 300,
  ),
];

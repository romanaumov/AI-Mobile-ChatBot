class AIProvider {
  final String name;
  final List<AIModel> models;

  AIProvider({
    required this.name,
    required this.models,
  });

  static List<AIProvider> getProviders() {
    return [
      AIProvider(
        name: 'OpenAI',
        models: [
          AIModel(id: 'gpt-3.5-turbo', name: 'GPT-3.5 Turbo'),
          AIModel(id: 'gpt-4', name: 'GPT-4'),
          AIModel(id: 'gpt-4-turbo', name: 'GPT-4 Turbo'),
          AIModel(id: 'gpt-4o', name: 'GPT-4o'),
        ],
      ),
      AIProvider(
        name: 'Anthropic',
        models: [
          AIModel(id: 'claude-2', name: 'Claude 2'),
          AIModel(id: 'claude-instant-1', name: 'Claude Instant'),
          AIModel(id: 'claude-3-opus', name: 'Claude 3 Opus'),
          AIModel(id: 'claude-3-sonnet', name: 'Claude 3 Sonnet'),
          AIModel(id: 'claude-3-haiku', name: 'Claude 3 Haiku'),
          AIModel(id: 'claude-3-7-sonnet-20250219', name: 'Claude 3.7 Sonnet'),
        ],
      ),
    ];
  }
}

class AIModel {
  final String id;
  final String name;

  AIModel({
    required this.id,
    required this.name,
  });
}

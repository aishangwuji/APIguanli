/// API Provider model representing a supported API platform
class ApiProvider {
  final String id;
  final String name;
  final String iconUrl;
  final String baseUrl;
  final bool isEnabled;

  const ApiProvider({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.baseUrl,
    this.isEnabled = true,
  });

  ApiProvider copyWith({
    String? id,
    String? name,
    String? iconUrl,
    String? baseUrl,
    bool? isEnabled,
  }) {
    return ApiProvider(
      id: id ?? this.id,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      baseUrl: baseUrl ?? this.baseUrl,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'iconUrl': iconUrl,
        'baseUrl': baseUrl,
        'isEnabled': isEnabled,
      };

  factory ApiProvider.fromJson(Map<String, dynamic> json) => ApiProvider(
        id: json['id'] as String,
        name: json['name'] as String,
        iconUrl: json['iconUrl'] as String,
        baseUrl: json['baseUrl'] as String,
        isEnabled: json['isEnabled'] as bool? ?? true,
      );

  /// Predefined supported providers
  static const openai = ApiProvider(
    id: 'openai',
    name: 'OpenAI',
    iconUrl: 'https://cdn.jsdelivr.net/gh/opendevmx/ionicons/png/2024/sharp/log-in-outline.png',
    baseUrl: 'https://api.openai.com',
  );

  static const deepseek = ApiProvider(
    id: 'deepseek',
    name: 'DeepSeek',
    iconUrl: 'https://cdn.jsdelivr.net/gh/opendevmx/ionicons/png/2024/sharp/construct-outline.png',
    baseUrl: 'https://api.deepseek.com',
  );

  static const anthropic = ApiProvider(
    id: 'anthropic',
    name: 'Anthropic',
    iconUrl: 'https://cdn.jsdelivr.net/gh/opendevmx/ionicons/png/2024/sharp/human-outline.png',
    baseUrl: 'https://api.anthropic.com',
  );

  static const googleGemini = ApiProvider(
    id: 'google_gemini',
    name: 'Google Gemini',
    iconUrl: 'https://cdn.jsdelivr.net/gh/opendevmx/ionicons/png/2024/sharp/logo-google.png',
    baseUrl: 'https://generativelanguage.googleapis.com',
  );

  static const zhipu = ApiProvider(
    id: 'zhipu',
    name: '智谱AI',
    iconUrl: 'https://cdn.jsdelivr.net/gh/opendevmx/ionicons/png/2024/sharp/analytics-outline.png',
    baseUrl: 'https://open.bigmodel.cn',
  );

  static const kimi = ApiProvider(
    id: 'kimi',
    name: 'Kimi',
    iconUrl: 'https://cdn.jsdelivr.net/gh/opendevmx/ionicons/png/2024/sharp/chatbubbles-outline.png',
    baseUrl: 'https://api.moonshot.cn',
  );

  static const oneapi = ApiProvider(
    id: 'oneapi',
    name: 'OneAPI',
    iconUrl: 'https://cdn.jsdelivr.net/gh/opendevmx/ionicons/png/2024/sharp/git-merge-outline.png',
    baseUrl: 'https://api.oneapi.mesh',
  );

  static List<ApiProvider> get allProviders => [
        openai,
        deepseek,
        anthropic,
        googleGemini,
        zhipu,
        kimi,
        oneapi,
      ];
}

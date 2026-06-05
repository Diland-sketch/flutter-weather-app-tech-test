enum Flavor { dev, prod }

class FlavorConfig {
  final Flavor flavor;
  final String appName;
  final String baseUrl;
  final String apiKey; 
  
  const FlavorConfig({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
    required this.apiKey,
  });

  static late FlavorConfig instance;

  bool get isDev => flavor == Flavor.dev;
  bool get isProd => flavor == Flavor.prod;
}
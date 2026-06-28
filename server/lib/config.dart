class ServerConfig {
  ServerConfig({
    required this.host,
    required this.port,
    required this.jwtSecret,
    required this.dataDir,
  });

  final String host;
  final int port;
  final String jwtSecret;
  final String dataDir;

  static const serverVersion = '1.0.0';
  static const minAppVersion = '1.0.44';
  static const apiVersion = 1;
  static const tokenTtlDays = 7;
}

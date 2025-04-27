class HTTPConfig {
  final dynamic uri;
  final dynamic body;
  final Map<String, String> headers;

  HTTPConfig({required this.uri, this.body, required this.headers});

  factory HTTPConfig.giveHeaders(dynamic uri, {dynamic body, dynamic token}) {
    return HTTPConfig(
        uri: uri,
        body: body ?? null,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
    );
  }
}
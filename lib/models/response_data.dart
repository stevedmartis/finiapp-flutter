import 'package:http/http.dart' as http;

class ResponseData {
  final List<int> bodyBytes;
  final int statusCode;
  final Map<String, String>? headers;
  final String? body;
  final int? contentLength;
  final bool? isRedirect;
  final bool? persistentConnection;
  final http.Request? request;

  ResponseData({
    required this.bodyBytes,
    required this.statusCode,
    this.headers,
    this.body,
    this.contentLength,
    this.isRedirect,
    this.persistentConnection,
    this.request,
  });
}

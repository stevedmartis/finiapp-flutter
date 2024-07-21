import 'package:finia_app/services/auth_service.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/http.dart' as http;

class TokenInterceptor implements InterceptorContract {
  final AuthService authService;

  TokenInterceptor(this.authService);

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    String? token = await authService.tokenStorage.getAccessToken();
    if (token != null) {
      data.headers['Authorization'] = 'Bearer $token';
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401) {
      bool refreshed = await authService.refreshToken();
      if (refreshed) {
        // Asegúrate de que data.request no es nulo antes de reenviar
        if (data.request != null) {
          return await _retryRequest(data.request!, authService);
        } else {}
      } else {}
    }
    return data;
  }

  Future<ResponseData> _retryRequest(
      RequestData originalRequest, AuthService authService) async {
    http.Request nativeRequest = convertToHttpRequest(originalRequest);
    http.StreamedResponse streamedResponse =
        await http.Client().send(nativeRequest);
    http.Response response = await http.Response.fromStream(streamedResponse);
    return convertToResponseData(response);
  }

  http.Request convertToHttpRequest(RequestData data) {
    var uri = Uri.parse(data.url);
    String method = methodToString(data.method); // Convert enum to string
    var request = http.Request(method, uri)
      ..headers.addAll(data.headers)
      ..body = data.body;
    return request;
  }

  ResponseData convertToResponseData(http.Response response) {
    return ResponseData(
        response.bodyBytes, // Assuming the bodyBytes is what you want
        response.statusCode);
  }
}

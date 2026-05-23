import 'package:http/http.dart' as real_http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();

Future<Map<String, String>> _getHeaders(Map<String, String>? extra) async {
  final token = await _storage.read(key: 'jwt_token');
  final headers = <String, String>{};
  if (token != null) {
    headers['Authorization'] = 'Bearer $token';
  }
  if (extra != null) {
    headers.addAll(extra);
  }
  return headers;
}

Future<real_http.Response> get(Uri url, {Map<String, String>? headers}) async {
  return real_http.get(url, headers: await _getHeaders(headers));
}

Future<real_http.Response> post(Uri url, {Map<String, String>? headers, Object? body}) async {
  return real_http.post(url, headers: await _getHeaders(headers), body: body);
}

Future<real_http.Response> patch(Uri url, {Map<String, String>? headers, Object? body}) async {
  return real_http.patch(url, headers: await _getHeaders(headers), body: body);
}

Future<real_http.Response> delete(Uri url, {Map<String, String>? headers, Object? body}) async {
  return real_http.delete(url, headers: await _getHeaders(headers), body: body);
}

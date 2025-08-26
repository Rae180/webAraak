import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

abstract class BaseApiService {
  Future<dynamic> getRequest({required String url});
  Future<dynamic> postRequest(
      {required String url, required Map<String, dynamic> jsonBody});
  Future<dynamic> postRequestAuth(
      {required String url, required Map<String, dynamic> jsonBody});
  Future<dynamic> postlogout({
    required String url,
  });
  Future<dynamic> multipartWithBytes({
    required String url,
    required Map<String, dynamic> jsonBody,
    Uint8List? fileBytes,
    String? filename,
  });
  Future<dynamic> multipart(
      {required String url,
      required Map<String, dynamic> jsonBody,
      File? file});
  Future<dynamic> multipart2({
    required String url,
    required Map<String, dynamic> jsonBody,
    required Map<String, dynamic> files,
  });

  Future<http.Response> getRequestAuth({
    required String url,
  });
  // Add delete request method
  Future<dynamic> delete({
    required String url,
  });
}

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:moviescollection/core/enums/http_error.dart';
import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/core/error_handling/exception_handler.dart';
import 'package:moviescollection/core/error_handling/wrapper_exception.dart';
import 'dart:convert' show utf8;

import 'package:moviescollection/core/utils/constants.dart';

class ApiProvider {
  final http.Client? httpClient;

  ApiProvider({@required this.httpClient});

  Future<dynamic> getRequest(String route, [String params = '']) async {
    Uri uri = Uri.parse(params.isEmpty
        ? '${Constant.baseUrl}/$route'
        : '${Constant.baseUrl}/$route?$params');

    return _requestBuilder(httpClient!.get(
      uri,
      headers: {
        'Content-type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
    ));
  }

  Future<dynamic> postRequest(String route, [Object? body]) async {
    Uri uri = Uri.parse('${Constant.baseUrl}/$route');

    return _requestBuilder(httpClient!.post(
      uri,
      headers: {
        'Content-type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: utf8.encode(json.encode(body)),
    ));
  }

  Future<dynamic> _requestBuilder(Future<Response> request,
      [bool isValidationRequest = false]) async {
    try {
      final response =
          await request.timeout(const Duration(seconds: 60), onTimeout: () {
        return throw WrapperException.handleWrapperException(
            HttpError.unavailable);
      });

      return _response(response, isValidationRequest);
    } on ArgumentError catch (_) {
      throw ServerException(
          code: HttpError.invalidArgument.value,
          message: HttpError.invalidArgument.name);
    } on SocketException catch (_) {
      throw ServerException(
          code: HttpError.noConnection.value,
          message: HttpError.noConnection.name);
    } on ExceptionHandler catch (exp) {
      ServerException error = (exp as ServerException);
      throw ServerException(code: error.code, message: error.message);
    }
  }

  dynamic _response(http.Response response,
      [bool isValidationRequest = false]) {
    // Successful Response (200 - 299)
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return jsonDecode(response.body);
    } else if (response.statusCode == HttpError.badRequest.value) {
      throw ServerException(
          code: HttpError.badRequest.value, message: HttpError.badRequest.name);
    } else if (response.statusCode == HttpError.unauthorized.value) {
      throw ServerException(
          code: HttpError.unauthorized.value,
          message: HttpError.unauthorized.name);
    } else if (response.statusCode == HttpError.forbidden.value) {
      throw ServerException(
          code: response.statusCode,
          message: utf8.decode(String.fromCharCodes(response.bodyBytes)
              .replaceAll('"', '')
              .runes
              .toList()));
    } else if (response.statusCode == HttpError.notFound.value) {
      throw ServerException(
          code: HttpError.notFound.value, message: HttpError.notFound.name);
    } else if (response.statusCode == HttpError.unProcessableEntity.value) {
      throw ServerException(
          code: HttpError.unProcessableEntity.value,
          message: HttpError.unProcessableEntity.name);
    } else if (response.statusCode == HttpError.internalError.value) {
      throw ServerException(
          code: HttpError.internalError.value,
          message: HttpError.internalError.name);
    } else if (response.statusCode == HttpError.unavailable.value) {
      throw ServerException(
          code: HttpError.unavailable.value,
          message: HttpError.unavailable.name);
    }
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:assets_challenge/core/exceptions/http_exceptions.dart';
import 'package:assets_challenge/core/helpers/internet_connection_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum TypeRequest { post, put, delete }

abstract class HttpHelper {
  Future<dynamic> getRequest(String url);
}

class HttpHelperImpl implements HttpHelper {
  final http.Client _httpClient;
  final InternetConnectionHelper _connectionHelper;

  @override
  HttpHelperImpl._(
    this._httpClient,
    this._connectionHelper,
  );

  static HttpHelperImpl? _instance;

  factory HttpHelperImpl(
    http.Client? client,
    InternetConnectionHelper connectionHelper,
  ) {
    _instance ??= HttpHelperImpl._(
      client!,
      connectionHelper,
    );
    return _instance!;
  }

  Future<bool> get isConnected => _connectionHelper.isConnected;

  @override
  Future<dynamic> getRequest(String url) async {
    return _handlerNoConnection(request: () async {
      try {
        log(
          url,
          name: 'FETCH URL',
          sequenceNumber: 1,
        );
        final uri = Uri.parse(url);
        final http.Response response = await _httpClient.get(
          uri,
        );

        log(
          response.statusCode.toString(),
          name: 'FETCH STATUS CODE',
          sequenceNumber: 2,
        );
        log(
          utf8.decode(response.bodyBytes),
          name: 'FETCH BODY',
          sequenceNumber: 3,
        );
        final statusCode = response.statusCode;
        dynamic json;
        if (response.body.isNotEmpty) {
          json = await compute(jsonDecode, utf8.decode(response.bodyBytes));
        }
        if (statusCode >= 200 && statusCode < 299) {
          if (response.body.isEmpty) {
            return [];
          }
          return json;
        } else if (statusCode >= 400 && statusCode < 500) {
          if (statusCode == 401) {
            log('isUnauthorized get');
          }
          throw ClientErrorException(
            code: statusCode,
            message: jsonEncode(json),
          );
        } else if (statusCode >= 500 && statusCode < 600) {
          throw ServerErrorException(
            code: statusCode,
            message: jsonEncode(json),
          );
        } else {
          throw const UnknownException();
        }
      } on SocketException catch (e) {
        log('Erro ao realizar o get $url', name: 'ERRO', error: e);
        throw const ConnectionException();
      }
    });
  }

  Future _handlerNoConnection({required Function request}) async {
    if (!await isConnected) {
      // _showErrorConnection();
      throw const ConnectionException();
    } else {
      return request();
    }
  }
}

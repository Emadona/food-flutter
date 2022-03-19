import 'dart:convert';

import 'package:auth/src/domain/credential.dart';
import 'package:async/async.dart';
import 'package:auth/src/domain/token.dart';
import '../../infra/api/auth_api_contract.dart';
import 'package:http/http.dart' as http;

import 'mapper.dart';

class AuthApi implements IAuthApi {
  final http.Client _client;
  String baseUrl;

  AuthApi(this.baseUrl, this._client);

  @override
  Future<Result<String>> signIn(Credential credential) async {
    var endpoint = baseUrl + '/auth/signin';
    return await _postCredential(endpoint, credential);
  }

  @override
  Future<Result<String>> signUp(Credential credential) async {
    var endpoint = baseUrl + '/auth/signup';
    return await _postCredential(endpoint, credential);
  }

  Future<Result<String>> _postCredential(
      String endpoint, Credential credential) async {
    var response = await _client.post(Uri.parse(endpoint),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(Mapper.toJson(credential)));
    print('response status code = ' + response.statusCode.toString());
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      return Result.error(_transformError(map));
    }
    var json = jsonDecode(response.body);
    return json['auth_token'] != null
        ? Result.value(json['auth_token'])
        : Result.error(json['message']);
  }

  @override
  Future<Result<bool>> signOut(Token token) async {
    var url = baseUrl + '/auth/signout';
    var headers = {
      "Content-type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(url), headers: headers);
    if (response.statusCode != 200) return Result.value(false);
    return Result.value(true);
  }

  _transformError(Map map) {
    var contents = map['error'] ?? map['errors'];
    if(contents is String) return contents;
    var errStr =
    contents.fold('', (prev, ele)=> prev + ele.values.first + '\n');

    return errStr.trim();
  }
}

import 'package:common/src/shared_api/http_client_contract.dart';
import 'package:http/http.dart';

class HttpClientImp implements IHttpClient {
  final Client _client;

  HttpClientImp(this._client);
  @override
  Future<HttpResult> get(Uri url, {Map<String, String>? headers}) async {
    final response = await _client.get(url, headers: headers);
    return HttpResult(data: response.body, status: _setStatus(response));
  }

  @override
  Future<HttpResult> post(Uri url, String, String body,
      {Map<String, String>? headers}) async {
    final response = await _client.post(url, body: body, headers: headers);
    return HttpResult(data: response.body, status: _setStatus(response));
  }

  _setStatus(Response response) {
    if (response.statusCode != 200) return Status.failure;
    return Status.success;
  }
}

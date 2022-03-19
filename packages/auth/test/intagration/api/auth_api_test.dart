// @dart=2.9
import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/domain/token.dart';
import 'package:auth/src/infra/api/auth_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  http.Client client;
  AuthApi sut;
  String baseUrl = "http://localhost:3000";

  setUp(() {
    client = http.Client();
    sut = AuthApi(baseUrl, client);
  });
  var credential = Credential(
      type: AuthType.email,
      name: 'Ahmed10',
      email: 'ahmed10@gmail.com',
      password: 'Al3almy1');
  group('sign in', () {
    test('should return json web token when successfully', () async {
      var result = await sut.signIn(credential);
      expect(result.asValue.value, isNotEmpty);
    });
  });

  group('sign out', () {
    test('should sign out user and return true', () async {
      // var tokenStr = await sut.signIn(credential);
      // ignore: prefer_const_constructors
      var token = Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjE1OTBhNTU5NTc1NDA2YmM4OWIyNzRmIiwiaWF0IjoxNjMzMjM3MDAzLCJleHAiOjE2MzMyNDA2MDMsImlzcyI6ImNvbS5mb29kYXBwIn0.FUtNMSIeNn_SzLZaAgKffixqCufFJwiHfgXsGODCJBo");
      var result = await sut.signOut(token);
      // print(tokenStr.asValue.value);
      expect(result.asValue.value, true);
    });
  });
}

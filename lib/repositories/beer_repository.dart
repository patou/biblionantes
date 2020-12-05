import 'package:biblionantes/models/Beer.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';

class FetchDataException implements Exception {
  final _message;
  final _prefix = 'Error during HTTP call: ';

  FetchDataException([this._message]);

  String toString() {
    return "$_prefix$_message";
  }
}

@immutable
class BeersRepository {
  final http.Client client;

  BeersRepository({@required this.client}) : assert(client != null);

  Future<List<Beer>> getBeers() async {
    final response =
    await client.get('https://api.punkapi.com/v2/beers?page=1&per_page=80');

    if (response.statusCode != 200) {
      throw FetchDataException(
          'error occurred when fetch beers from punk API: {$response.statusCode}');
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<Beer>((json) => Beer.fromJson(json)).toList();
  }
}
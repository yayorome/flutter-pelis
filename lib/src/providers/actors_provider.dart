import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pelis/src/model/actors_model.dart';

class ActorsProvider {
  String _apiKey = 'f08a0d4cc5d0cdc4094ce09bf883048f';
  String _endpoint = 'api.themoviedb.org';
  // bool _loading = false;

  Future<List<Actor>> getActors(String movieId) async {
    Map<String, String> parameters = {'api_key': _apiKey};
    final url = Uri.https(_endpoint, '3/movie/$movieId/credits', parameters);
    final response = await http.get(url);
    final decoded = json.decode(response.body);
    final actors = new Actors.fromJsonList(decoded['cast']);
    return actors.actors;
  }
}

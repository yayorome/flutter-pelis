import 'dart:async';
import 'dart:convert';

import 'package:pelis/src/model/movies_model.dart';
import 'package:http/http.dart' as http;

class MoviesProvider {
  String _apiKey = 'f08a0d4cc5d0cdc4094ce09bf883048f';
  String _endpoint = 'api.themoviedb.org';
  String _lang = 'es-MX';
  int _page = 0;
  List<Movie> _populares = List<Movie>();
  bool _loading = false;

  final _popularesStreamController = StreamController<List<Movie>>.broadcast();
  Function(List<Movie>) get popularSink => _popularesStreamController.sink.add;
  Stream<List<Movie>> get popularStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController.close();
  }

  Future<List<Movie>> getNowPlaying() async {
    Map<String, String> parameters = {'api_key': _apiKey, 'language': _lang};
    final url = Uri.https(_endpoint, '3/movie/now_playing', parameters);
    return await _processResponse(url);
  }

  Future<List<Movie>> getPopular() async {
    if (_loading) return [];
    _loading = true;
    _page++;

    Map<String, String> parameters = {
      'api_key': _apiKey,
      'language': _lang,
      'page': _page.toString()
    };
    final url = Uri.https(_endpoint, '3/movie/popular', parameters);
    final response = await _processResponse(url);

    _populares.addAll(response);
    popularSink(_populares);

    _loading = false;
    return response;
  }

  Future<List<Movie>> getMovie(String nameish) async {
    Map<String, String> parameters = {
      'api_key': _apiKey,
      'language': _lang,
      'query': nameish
    };
    final url = Uri.https(_endpoint, '3/search/movie', parameters);
    return await _processResponse(url);
  }

  Future<List<Movie>> _processResponse(Uri url) async {
    final response = await http.get(url);
    final decoded = json.decode(response.body);
    final movies = new Movies.fromJsonList(decoded['results']);
    return movies.movies;
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:pelis/src/model/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apiKey = 'f08a0d4cc5d0cdc4094ce09bf883048f';
  String _endpoint = 'api.themoviedb.org';
  String _lang = 'es-MX';
  int _page = 0;
  List<Pelicula> _populares = List<Pelicula>();
  bool _loading = false;

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();
  Function(List<Pelicula>) get popularSink =>
      _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController.close();
  }

  Future<List<Pelicula>> getNowPlaying() async {
    Map<String, String> parameters = {'api_key': _apiKey, 'language': _lang};
    final url = Uri.https(_endpoint, '3/movie/now_playing', parameters);
    return await _processResponse(url);
  }

  Future<List<Pelicula>> getPopular() async {
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

  Future<List<Pelicula>> _processResponse(Uri url) async {
    final response = await http.get(url);
    final decoded = json.decode(response.body);
    final peliculas = new Peliculas.fromJsonList(decoded['results']);
    return peliculas.peliculas;
  }
}

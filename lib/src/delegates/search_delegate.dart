import 'package:flutter/material.dart';
import 'package:pelis/src/model/movies_model.dart';
import 'package:pelis/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {
  final moviesProvider = MoviesProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    //Actions del appbar
    List<Widget> list = List<Widget>();
    list.add(IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        }));
    return list;
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Resultados de la busqueda
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias cuando el usuario escribe
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: moviesProvider.getMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          final movieList = snapshot.data;

          return ListView(
              children: movieList.map((movie) {
            return ListTile(
              leading: FadeInImage(
                placeholder: AssetImage('assets/img/img-loading.gif'),
                image: NetworkImage(movie.getPosterImg()),
                fit: BoxFit.contain,
                width: 50,
              ),
              title: Text(movie.title),
              subtitle: Text(movie.originalTitle),
              onTap: () {
                close(context, null);
                movie.uid = '';
                Navigator.pushNamed(context, 'detail', arguments: movie);
              },
            );
          }).toList());
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  /*@override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias cuando el usuario escribe

    final filterList = (query.isEmpty)
        ? rec
        : pelis
            .where((element) =>
                element.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: filterList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.movie_filter),
          title: Text(filterList[index]),
          onTap: () {
            movieSelected = filterList[index];
            showResults(context);
          },
        );
      },
    );
  }*/
}

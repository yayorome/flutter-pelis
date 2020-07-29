import 'package:flutter/material.dart';
import 'package:pelis/src/model/movies_model.dart';

class MovieHorizontalWidget extends StatelessWidget {
  final List<Movie> peliculas;
  final _pageController = PageController(initialPage: 1, viewportFraction: 0.3);
  final Function nextPage;

  MovieHorizontalWidget({@required this.peliculas, @required this.nextPage});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.22,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (context, i) => _card(context, peliculas[i]),
      ),
    );
  }

  Widget _card(BuildContext context, Movie movie) {
    movie.uid = '${movie.id}-popular';
    final card = Container(
      margin: EdgeInsets.only(right: 15),
      child: Column(
        children: <Widget>[
          Hero(
            tag: movie.uid,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                image: NetworkImage(movie.getPosterImg()),
                placeholder: AssetImage('assets/img/img-loading.gif'),
                fit: BoxFit.cover,
                height: 140,
              ),
            ),
          ),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      child: card,
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
    );
  }

  /*List<Widget> _cards(BuildContext context) {
    return peliculas.map((e) {
      return Container(
        margin: EdgeInsets.only(right: 15),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                image: NetworkImage(e.getPosterImg()),
                placeholder: AssetImage('assets/img/img-loading.gif'),
                fit: BoxFit.cover,
                height: 140,
              ),
            ),
            Text(
              e.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }*/
}

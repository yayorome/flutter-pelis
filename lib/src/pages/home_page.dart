import 'package:flutter/material.dart';
import 'package:pelis/src/delegates/search_delegate.dart';
import 'package:pelis/src/providers/movies_provider.dart';
import 'package:pelis/src/widgets/card_swiper_widget.dart';
import 'package:pelis/src/widgets/movie_horizontal_widget.dart';

class HomePage extends StatelessWidget {
  final moviesProvider = MoviesProvider();

  @override
  Widget build(BuildContext context) {
    moviesProvider.getPopular();
    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas Recientes'),
        centerTitle: false,
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[_swiperTarjetas(), _popularMovies(context)],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: moviesProvider.getNowPlaying(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiperWidget(cardList: snapshot.data);
        } else {
          return Container(
              height: 300, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _popularMovies(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Populares',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          StreamBuilder(
            stream: moviesProvider.popularStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontalWidget(
                    peliculas: snapshot.data,
                    nextPage: moviesProvider.getPopular);
              } else {
                return Container(
                    height: 340,
                    child: Center(child: CircularProgressIndicator()));
              }
            },
          ),
        ],
      ),
    );
  }
}

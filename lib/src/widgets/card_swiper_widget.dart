import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pelis/src/model/movies_model.dart';

class CardSwiperWidget extends StatelessWidget {
  final List<Movie> cardList;

  CardSwiperWidget({@required this.cardList});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      // padding: EdgeInsets.only(top: 10),
      child: Swiper(
          itemWidth: _screenSize.width * 0.5,
          itemHeight: _screenSize.width * 0.8,
          itemCount: cardList.length,
          layout: SwiperLayout.STACK,
          itemBuilder: (BuildContext context, int index) =>
              _card(context, cardList[index])),
    );
  }

  Widget _card(BuildContext context, Movie movie) {
    movie.uid = '${movie.id}-cards';
    final card = Hero(
      tag: movie.uid,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FadeInImage(
            image: NetworkImage(movie.getPosterImg()),
            placeholder: AssetImage('assets/img/img-loading.gif'),
            fit: BoxFit.cover,
          )),
    );

    return GestureDetector(
      child: card,
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
    );
  }
}

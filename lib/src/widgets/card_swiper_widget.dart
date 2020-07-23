import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pelis/src/model/pelicula_model.dart';

class CardSwiperWidget extends StatelessWidget {
  final List<Pelicula> cardList;

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
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                image: NetworkImage(cardList[index].getPosterImg()),
                placeholder: AssetImage('assets/img/img-loading.gif'),
                fit: BoxFit.cover,
              ));
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pelis/src/model/actors_model.dart';
import 'package:pelis/src/model/movies_model.dart';
import 'package:pelis/src/providers/actors_provider.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppBar(movie),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
            height: 10,
          ),
          _titlePoster(context, movie),
          _description(movie),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Actores',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _cast(movie)
        ]))
      ],
    ));
  }

  Widget _crearAppBar(Movie movie) {
    return SliverAppBar(
      elevation: 2,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie.title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        background: FadeInImage(
          fit: BoxFit.cover,
          image: NetworkImage(movie.getBackGroundImg()),
          placeholder: AssetImage('assets/img/img-loading.gif'),
          fadeInDuration: Duration(milliseconds: 150),
        ),
      ),
    );
  }

  Widget _titlePoster(BuildContext context, Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uid,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(movie.getPosterImg()),
                height: 150,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headline6,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                movie.originalTitle,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.star_border),
                  Text(
                    movie.voteAverage.toString(),
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _description(Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _cast(Movie movie) {
    final ActorsProvider _actorsProvider = ActorsProvider();
    return FutureBuilder(
      future: _actorsProvider.getActors(movie.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _crearCastView(snapshot.data);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearCastView(List<Actor> actors) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
          pageSnapping: false,
          itemCount: actors.length,
          controller: PageController(viewportFraction: 0.3, initialPage: 1),
          itemBuilder: (context, index) => _castCard(actors[index])),
    );
  }

  Widget _castCard(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
                height: 150,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/img/img-loading.gif'),
                image: NetworkImage(actor.getActorPhoto())),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

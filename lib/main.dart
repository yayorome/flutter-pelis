import 'package:flutter/material.dart';
import 'package:pelis/src/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Peliculas',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: getAppRoutes());
  }
}

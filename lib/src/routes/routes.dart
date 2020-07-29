import 'package:flutter/material.dart';
import 'package:pelis/src/pages/detail_page.dart';
import 'package:pelis/src/pages/home_page.dart';

Map<String, WidgetBuilder> getAppRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => HomePage(),
    'detail': (BuildContext context) => DetailPage(),
  };
}

library;

import 'package:flutter/material.dart';
import 'package:s3t/widgets/g_screen.dart';
import 'package:s3t/widgets/main_screen.dart';
import 'package:s3t/widgets/mg_screen.dart';
import 'routes.dart';

class AppRoute {
  static Route<dynamic> generate(RouteSettings? settings) {
    switch (settings?.name) {
      case RoutesName.game:
        return MaterialPageRoute(
          builder: (context) => MyHomePage(
            title: 'Room #313',
          ),
        );
      case RoutesName.mini:
        return MaterialPageRoute(
          builder: (context) => MgScreen(),
        );
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (context) => MainScreen(),
        );

      default:
      return MaterialPageRoute(
          builder: (context) => Test(),
        );
    }
  }
}


class Test extends StatelessWidget{
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("error"),),
    );
  }

}
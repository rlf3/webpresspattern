import 'package:flutter/material.dart';

import 'package:webpresspattern/main.dart';

import 'login_signup_page.dart';
import 'package:webpresspattern/services/authentication.dart';
import 'page_profile.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyApp());
      break;
      case '/login':
        // Validation of correct data type
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => LoginSignUpPage(auth: new Auth()),
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute();
      break;


      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfilePage());
      break;



      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}


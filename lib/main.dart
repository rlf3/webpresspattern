import 'package:flutter/material.dart';
import 'package:webpresspattern/services/authentication.dart';
import 'package:webpresspattern/pages/root_page.dart';
import 'package:flutter/rendering.dart';
import 'package:custom_splash/custom_splash.dart';


void main() {

  Function duringSplash = () {
    print('Something background process');
    int a = 123 + 23;
    print(a);

    if (a > 100)
      return 1;
    else
      return 2;
  };



  //debugPaintSizeEnabled = true;
  //runApp(new MyApp());

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CustomSplash(
      
      imagePath: 'assets/flutter-icon.png',
      backGroundColor: Colors.white,
      // backGroundColor: Color(0xfffc6042),
      animationEffect: 'zoom-in',
      logoSize: 200,
      home: MyApp(),
      customFunction: duringSplash,
      duration: 2500,
      type: CustomSplashType.StaticDuration,
      //outputAndHome: op,
    ),
  ));

  

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Web press Login',
        debugShowCheckedModeBanner: false,
        
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth()));
  }
}

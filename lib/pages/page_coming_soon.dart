
import 'package:flutter/material.dart';
import 'package:webpresspattern/utils/utils.dart';
import 'package:webpresspattern/services/authentication.dart';

class PageComingSoon extends StatefulWidget {
    PageComingSoon({Key key, this.auth, this.userId
    , this.onSignedOut
    })
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  
  @override
  _PageComingSoonState createState() => _PageComingSoonState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _PageComingSoonState extends State<PageComingSoon> {
  
  String _userId = "";
  Screen size;
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  //String _userId = "";

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
      });
    });

    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          //title: Text("Dashboard",
          title: Text(_userId,
              style:
              TextStyle(fontFamily: "Exo2", color: backgroundColor)),
          backgroundColor: colorCurve,
        ),
        body: Center(
            child: Container(
                width: size.getWidthPx(300),
                height: size.getWidthPx(300),
                child: Image.asset("assets/icons/icn_coming_soon.png")))
    );
  }

}
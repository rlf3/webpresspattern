import 'package:flutter/material.dart';

import 'package:webpresspattern/pages/root_page.dart';
import 'package:webpresspattern/services/authentication.dart';


import 'package:flutter/services.dart';
import 'package:webpresspattern/utils/utils.dart';
import 'package:webpresspattern/widgets/widgets.dart';
import 'route_generator.dart';

import 'page_profile.dart';


class SettingPage extends StatefulWidget {
   SettingPage({Key key, this.auth, this.userId
    , this.onSignedOut
    })
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  @override
  _SettingPageState createState() => _SettingPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _SettingPageState extends State<SettingPage> {









  final List<String> myList = ["Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: ", " ", "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.", " ",  "THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."];

  List<Widget> getMyList(){
    return myList.map((x){
      return Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(children: <Widget>[//row
          //Icon(Icons.supervisor_account),
          Text(x)
        ]),
      );
    }).toList();
  }






  void showMyDialog(BuildContext context) async{
    showDialog(
      context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(10.0),
            contentPadding: EdgeInsets.all(0.0),
            title: Text("Terms and conditionss"),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(
                    height: 1.0,
                    color: Colors.grey,
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: getMyList()
                      ),
                    ),
                  ),

                  Divider(
                    color: Colors.grey,
                    height: 1.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0, bottom: 5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4.0), topLeft: Radius.circular(4.0))),
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ]
            ),
          );
        }
    );
  }













  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }



  void _showPasswordResetEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your email"),
          content: new Text("Link to Reset password account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

 
























   
  
  String _userId = "";
  String _userEmail = "";
  Screen size;
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  bool isLocalNotification = false;
  bool isPushNotification = true;
  bool isPrivateAccount = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }
  @override
  Widget build(BuildContext context) {


    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
        _userEmail = user.email.toString();
      });
    });



    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //title: Text("Settings $_userId",
        //title: Text("$_userId",
        title: Text("Settings",
            style:
                TextStyle(fontFamily: "Exo2", color: textSecondaryLightColor)),
            backgroundColor: Colors.white,
      ),
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarColor: backgroundColor,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarColor: backgroundColor),
        child: Container(
          color: backgroundColor,
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                accountSection(),
                pushNotificationSection(),
                getHelpSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SettingSection getHelpSection() {
    return SettingSection(
      headerText: "Get Help".toUpperCase(),
      headerFontSize: 15.0,
      headerTextColor: Colors.black87,
      backgroundColor: Colors.white,
      disableDivider: false,
      children: <Widget>[
        Container(
          child: TileRow(
            label: "Contact Us",
            disableDivider: false,
            onTap: () {},
          ),
        ),
        Container(
          child: TileRow(
            label: "Terms and Condition",
            disableDivider: false,
            onTap: () {
              showMyDialog(context);
            },
          ),
        ),
        Container(
          child: TileRow(
            label: "Feedback",
            disableDivider: false,
            onTap: () {},
          ),
        ),
        Container(
          child: TileRow(
            label: "Log out",
            disableDivider: false,
            onTap: () {
              //_signOut();
              //Navigator.pushNamed(context, '/login');
              //Navigator.of(context).pushNamed('/profile');

              //Navigator.push(context, RouteGenerator.generateRoute());

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RootPage(auth: new Auth(),),));
              

              //_signOut();
            },
          ),
        )
      ],
    );
  }

  SettingSection accountSection() {
    return SettingSection(
      headerText: "Account".toUpperCase(),
      headerFontSize: 15.0,
      headerTextColor: Colors.black87,
      backgroundColor: Colors.white,
      disableDivider: false,
      children: <Widget>[
        Container(
          child: TileRow(
            label: "User Name",
            //disabled: true,
            rowValue: "harsh719",
            disableDivider: false,
            onTap: () {

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ProfilePage(
                      userId: _userId,
                      auth: widget.auth,
                      onSignedOut: _onSignedOut,
              ),));
              
            },
          ),
        ),
/*         Container(
          child: SwitchRow(
            label: "Private Account",
            disableDivider: false,
            value: isPrivateAccount,
            onSwitchChange: (switchStatus) {
              setState(() {
                switchStatus
                    ? isPrivateAccount = true
                    : isPrivateAccount = false;
              });
            },
            onTap: () {},
          ),
        ), */
        Container(
          child: TileRow(
            label: "Change Password",
            disableDivider: false,
            onTap: () {

            //widget.auth.getCurrentUser().then(user).;
          widget.auth.resetPassword(_userEmail);
          print(_userEmail);
          _showPasswordResetEmailSentDialog();

              
            },
          ),
        )
      ],
    );
  }

  SettingSection pushNotificationSection() {
    return SettingSection(
      headerText: "Push Notifications".toUpperCase(),
      headerFontSize: 15.0,
      headerTextColor: Colors.black87,
      backgroundColor: Colors.white,
      disableDivider: false,
      children: <Widget>[
        Container(
          child: SwitchRow(
            label: "Push Notification",
            disableDivider: false,
            value: isPushNotification,
            onSwitchChange: (switchStatus) {
              setState(() {
                switchStatus
                    ? isPushNotification = true
                    : isPushNotification = false;
              });
            },
            onTap: () {},
          ),
        ),
        Container(
          child: SwitchRow(
            label: "Local Notification",
            disableDivider: false,
            value: isLocalNotification,
            onSwitchChange: (switchStatus) {
              setState(() {
                switchStatus
                    ? isLocalNotification = true
                    : isLocalNotification = false;
              });
            },
            onTap: () {},
          ),
        )
      ],
    );
  }
}

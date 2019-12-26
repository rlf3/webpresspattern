import 'package:flutter/material.dart';
import 'package:webpresspattern/pages/dash_board.dart';
import 'package:webpresspattern/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:webpresspattern/models/todo.dart';
import 'dart:async';
import 'package:webpresspattern/constants.dart';
import 'package:webpresspattern/widgets/bottom_navigationBar.dart';
import 'page_search.dart';
import 'page_coming_soon.dart';
import 'page_profile.dart';
import 'page_settings.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
//import 'package:webpresspattern/services/flutter_ringtone_player.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}



enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}
class _HomePageState extends State<HomePage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;



  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }




  int currentTab = 0;
  PageController pageController;

  String _userId = "";

  
  List<Todo> _todoList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _todoQuery;

  bool _isEmailVerified = false;


  _changeCurrentTab(int tab) {
    //Changing tabs from BottomNavigationBar
    setState(() {
      currentTab = tab;
      pageController.jumpToPage(0);
    });
  }


  @override
  void initState() {
    super.initState();


    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
        //widget.userId = user.uid.toString();
      });
    });




    _checkEmailVerification();
    _userId = widget.userId;
    _todoList = new List();
    _todoQuery = _database
        .reference()
        .child("todo")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(_onEntryAdded);
    _onTodoChangedSubscription = _todoQuery.onChildChanged.listen(_onEntryChanged);


    pageController = new PageController();
  }


  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      print(_isEmailVerified);
      _showVerifyEmailDialog();
      //Navigator.of(context).pop();
      Navigator.pushNamed(context, '/login');
      _signOut();
    }
  }

  void _resentVerifyEmail(){
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _signOut();
                Navigator.of(context).pop();
                
                //Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _signOut();
                Navigator.of(context).pop();
                
              },
            ),
          ],
        );
      },
    );
  }













///////////////////Show User /////////////
///

  _showName() {
    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
      });
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Current User"),
          content: new Text(_userId),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                //_signOut();
                Navigator.of(context).pop();
                
              },
            ),
          ],
        );
      },
    );
  }


/////////////////////////////////////////










  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  _onEntryChanged(Event event) {
    var oldEntry = _todoList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _todoList[_todoList.indexOf(oldEntry)] = Todo.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      _todoList.add(Todo.fromSnapshot(event.snapshot));
    });
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }



  _addNewTodo(String todoItem) {
    if (todoItem.length > 0) {

      Todo todo = new Todo(todoItem.toString(), widget.userId, false);
      _database.reference().child("todo").push().set(todo.toJson());
    }
  }

  _updateTodo(Todo todo){
    //Toggle completed
    todo.completed = !todo.completed;
    if (todo != null) {
      _database.reference().child("todo").child(todo.key).set(todo.toJson());
    }
  }

  _deleteTodo(String todoId, int index) {
    _database.reference().child("todo").child(todoId).remove().then((_) {
      print("Delete $todoId successful");
      setState(() {
        _todoList.removeAt(index);
      });
    });
  }

  _showDialog(BuildContext context) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
      builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(child: new TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Add new todo',
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    _addNewTodo(_textEditingController.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
      }
    );
  }





  Widget _showTodoList() {
    if (_todoList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _todoList.length,
          itemBuilder: (BuildContext context, int index) {
            String todoId = _todoList[index].key;
            String subject = _todoList[index].subject;
            bool completed = _todoList[index].completed;
            String userId = _todoList[index].userId;
            return Dismissible(
              key: Key(todoId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                _deleteTodo(todoId, index);
              },
              child: ListTile(
                title: Text(
                  subject,
                  style: TextStyle(fontSize: 20.0),
                ),
                trailing: IconButton(
                    icon: (completed)
                        ? Icon(
                      Icons.done_outline,
                      color: Colors.green,
                      size: 20.0,
                    )
                        : Icon(Icons.done, color: Colors.grey, size: 20.0),
                    onPressed: () {
                      _updateTodo(_todoList[index]);
                    }),
              ),
            );
          });
    } else {
      return Center(child: Text("Welcome. Your list is empty",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),));
    }
  }

































//Main widget 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          //leading: Icon(Icons.home),
          title: new Text(appName),
          //title: new Text(_userId),
          actions: <Widget>[
                
                new IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: (){
                      //_showName();
                      FlutterRingtonePlayer.play(
                      android: AndroidSounds.notification,
                      ios: IosSounds.glass,
                      looping: true, // Android only - API >= 28
                      volume: 0.1, // Android only - API >= 28
                      asAlarm: false, // Android only - all APIs
                      );
                  },
                ),
                

                

                new PopupMenuButton(
                  itemBuilder: (BuildContext context){
                    return [

                        PopupMenuItem(
                          child: new  FlatButton(
                            child: new Text('Logout',
                            style: new TextStyle(fontSize: 17.0, color: Colors.blue)),
                            onPressed: _signOut),

                           

                        ),    

                                          

                    ];
                  },
                ),



                
          ],
        ),
        //body: _showTodoList(),
        body: bodyView(currentTab),
/*         floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showDialog(context);
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), */
        bottomNavigationBar: BottomNavBar(changeCurrentTab: _changeCurrentTab)
    );
  }



  bodyView(currentTab) {
    List<Widget> tabView = [];
    //Current Tabs in Home Screen...
    switch (currentTab) {
      case 0:
        //Dashboard Page
        tabView = [DashBoard(
                      userId: _userId,
                      auth: widget.auth,
                      onSignedOut: _onSignedOut,
        )];
        break;
      case 1:
        //Search Page
        tabView = [SearchPage()];
        break;
      case 2:
        //Profile Page
        tabView = [ProfilePage(
                      userId: _userId,
                      auth: widget.auth,
                      onSignedOut: _onSignedOut,          
        )];
        break;
      case 3:
        //Setting Page
        tabView = [ new SettingPage(
                      userId: _userId,
                      auth: widget.auth,
                      onSignedOut: _onSignedOut,
        )];
        break;
    }
    return PageView(controller: pageController, children: tabView);
  }

}


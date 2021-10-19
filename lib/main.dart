import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const platform = const MethodChannel('samples.microsoft.com/calling');

  String _userName = '';
  String _authToken = '';
  String _callType = 'group_call';
  String _groupCallId = '';
  String _meetingLink = '';

  Future<void> _join() async {
    try {
      await platform.invokeMethod('startCallingExperience',
          <String, dynamic>{
            'userName': _userName,
            'authToken': _authToken,
            'callType': _callType,
            'groupCallId': _groupCallId,
            'meetingLink': _meetingLink
          });

    } on PlatformException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
      child: Container(
        padding: EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(hintText: 'Your name'),
              onChanged: (String string) {
                setState(() {
                  _userName = string;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Auth token'),
              onChanged: (String string) {
                setState(() {
                  _authToken = string;
                });
              },
            ),
            DropdownButton(
              isExpanded: true,
              items: [
                DropdownMenuItem(
                    value: "group_call", child: Text("Join Group Call")),
                DropdownMenuItem(
                    value: "team_meeting", child: Text("Join Team Meeting"))
              ],
              value: _callType,
              onChanged: (String? value) {
                if (value != null) onCallTypeChanged(value);
              },
            ),
            Visibility(
                visible: _callType == "group_call",
                child: TextField(
                    decoration: InputDecoration(hintText: 'Group Call ID'),
                    onChanged: (String string) {
                      setState(() {
                        _groupCallId = string;
                      });
                    })),
            Visibility(
                visible: _callType == "team_meeting",
                child: TextField(
                    decoration: InputDecoration(hintText: 'Teams meeting link'),
                    onChanged: (String string) {
                      setState(() {
                        _meetingLink = string;
                      });
                    })),
            ElevatedButton(
              child: Text('Join'),
              onPressed: _join,
            ),
          ],
        ),
      ),
    ));
  }

  onCallTypeChanged(String callType) {
    setState(() {
      _callType = callType;
      _groupCallId = '';
      _meetingLink = '';
    });
  }
}

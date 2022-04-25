import 'dart:async';
import 'package:flutter/material.dart';
import 'package:research_alert/core/services/notification_service.dart';
import 'package:research_alert/drawer/main_drawer.dart';
import 'package:research_alert/ui/screens/add_note/add_notes.dart';
import 'package:research_alert/ui/screens/add_bookmarks_screen.dart';
import '../custom_widgets/bottombar.dart';
import '../custom_widgets/list_button.dart';
import '../custom_widgets/list_data.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // var currentPage = DrawerSections.dashboard;
  // ignore: unused_field
  late StreamSubscription _intentDataStreamSubscription;
  // ignore: unused_field
  List<SharedMediaFile>? _sharedFiles;
  // ignore: unused_field
  String? _sharedText;

  @override
  void initState() {
    super.initState();

    listenNotification();
    // For sharing or opening urls/text coming from outside the app
    // while the app is in the memory

    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value.contains('https://youtu.be')) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddBookmarksScreen(text: value)));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddTodo(text: value)));
      }
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while
    // the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value != null) {
        if (value.contains('https://youtu.be')) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddBookmarksScreen(text: value)));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTodo(text: value)));
        }
      }
    });
  }

  listenNotification() {
    NotificationService.onNotifications.stream.listen(onClickedNotification);
  }

  onClickedNotification(String? payload) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomBar(onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddTodo(
                      text: '',
                    )));
      }),
      body: SafeArea(
        child: ListView(
          children: [
            // CustomAppBar(),
            // SearchBar(),
            ListButtonContainer(),
            Listdata(),
            // ShowDataPage(),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 53, 51),
        title: Text("Research Alert"),
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          null,
          0,
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: Color.fromARGB(255, 34, 53, 51),
      //   title: Text("Research Alert"),
      // ),
      drawer: MainDrawer(),
    );
  }
}

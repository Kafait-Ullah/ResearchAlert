import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:research_alert/core/models/notes_model.dart';
import 'package:research_alert/core/services/database_services.dart';
import 'package:research_alert/core/services/notification_service.dart';
import 'package:research_alert/core/utils/alert_dialog.dart';
import 'package:research_alert/ui/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateBookmarkScreen extends StatefulWidget {
  Notes notes;
  DocumentReference ref;

  UpdateBookmarkScreen({required this.notes, required this.ref});

  @override
  State<UpdateBookmarkScreen> createState() => _UpdateBookmarkScreenState();
}

class _UpdateBookmarkScreenState extends State<UpdateBookmarkScreen> {
  DataBaseServices _dataBaseServices = DataBaseServices();

  NotificationService _notificationService = NotificationService();

  TextEditingController _titleC = TextEditingController();
  TextEditingController _descC = TextEditingController();

  bool isBold = false;
  bool isLoading = false;

  DateTime? dateTime;

  @override
  void initState() {
    super.initState();

    NotificationService.init();
    // listenNotification();

    _titleC.text = widget.notes.title;
    _descC.text = widget.notes.desc;
    dateTime = widget.notes.reminder.toDate();
  }

  toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  String getFormattedDataTime(DateTime dateTime) {
    final myDateTime =
        DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);

    var formattedDate = DateFormat('dd MMM yyyy  hh:mm a').format(myDateTime);

    return formattedDate;
  }

  onConfirmDateTime(DateTime dateTimeIs) {
    FocusScope.of(context).unfocus();
    setState(() {
      dateTime = dateTimeIs;
    });

    final mydateTime =
        DateTime.fromMillisecondsSinceEpoch(dateTime!.millisecondsSinceEpoch);

    var formattedDate = DateFormat('dd MMM yyyy  hh:mm a').format(mydateTime);

    print('date in human read $formattedDate');
  }

  Future<void> handleScheduleNotification() async {
    try {
      await _notificationService.showScheduledNotification(
        title: _titleC.text,
        body: _descC.text,
        payload: 'def',
        // scheduleDateTime:
        //     DateTime.now().add(Duration(seconds: 3)),
        scheduleDateTime: dateTime,
      );

      // showAlertDialog(context, 'Notification', 'Scheduled');
    } catch (e) {
      print('Error ' + e.toString());
    }
  }

  updateBookmark() async {
    try {
      if (_titleC.text.isNotEmpty &&
          _descC.text.isNotEmpty &&
          dateTime != null) {
        toggleLoading(true);

        await handleScheduleNotification();

        await _dataBaseServices.updateBookMarksData(
            widget.ref, _titleC.text, _descC.text, dateTime!);

        toggleLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bookmark Updated Successfully'),
          ),
        );

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
      } else {
        showAlertDialog(context, 'Error', 'Please Input all field');
      }
    } catch (e) {
      showAlertDialog(
          context, 'Error', 'Some error occurred while updating data');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    const textStyleBold = const TextStyle(fontWeight: FontWeight.bold);
    // ignore: unused_local_variable
    var width = MediaQuery.of(context).size.width / 2;

    return MaterialApp(
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.black45,
              ),
            ),
            title: const Text(
              'Bookmark',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 15.0),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _titleC,
                            decoration: InputDecoration.collapsed(
                                hintText: "Title",
                                hintStyle: TextStyle(
                                  fontSize: 28.0,
                                  fontFamily: "lato",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45.withOpacity(0.5),
                                )),
                            style: TextStyle(
                              fontSize: 28.0,
                              fontFamily: "lato",
                              fontWeight: FontWeight.bold,
                              color: Colors.black45.withOpacity(0.6),
                            ),
                          ),
//
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: dateTime != null
                                ? Row(
                                    children: [
                                      Icon(Icons.alarm,
                                          color: Colors.blue, size: 18),
                                      SizedBox(width: 5),
                                      Text(
                                        getFormattedDataTime(dateTime!),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: "lato",
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(''),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 100),
                            child: Linkify(
                              onOpen: (link) async {
                                if (await canLaunch(link.url)) {
                                  await launch(link.url);
                                } else {
                                  print('Could not launch $link');
                                }
                              },
                              text: '${_descC.text}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              linkStyle: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

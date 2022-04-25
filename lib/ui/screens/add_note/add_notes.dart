import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:research_alert/core/services/database_services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:research_alert/core/services/notification_service.dart';
import 'package:research_alert/core/utils/alert_dialog.dart';
import 'package:research_alert/ui/custom_widgets/custom_bottom_bar_notes.dart';
import 'package:research_alert/ui/screens/home_screen.dart';

// ignore: must_be_immutable
class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();

  String? text;

  AddTodo({required this.text});
}

class _AddTodoState extends State<AddTodo> {
  DataBaseServices _dataBaseServices = DataBaseServices();

  NotificationService _notificationService = NotificationService();

  TextEditingController _titleC = TextEditingController();
  TextEditingController _descC = TextEditingController();
  // QuillController _descC = QuillController.basic();
  // ignore: unused_field
  TextEditingController _scheduleC = TextEditingController();

  bool isBold = false;
  bool isLoading = false;

  DateTime? dateTime;

  @override
  void initState() {
    super.initState();

    _descC.text = widget.text ?? '';
    NotificationService.init();
  }

  toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  onConfirmDateTime(DateTime dateTimeIs) {
    FocusScope.of(context).unfocus();
    setState(() {
      dateTime = dateTimeIs;
    });

    final mydateTime =
        DateTime.fromMillisecondsSinceEpoch(dateTime!.millisecondsSinceEpoch);

    var formattedDate = DateFormat('dd MMM yyyy  hh:mm:ss').format(mydateTime);

    print('date in human read $formattedDate');
  }

  String getFormattedDataTime(DateTime dateTime) {
    final myDateTime =
        DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);

    var formattedDate = DateFormat('dd MMM yyyy  hh:mm a').format(myDateTime);

    return formattedDate;
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

  Future<void> handleAddNote() async {
    FocusScope.of(context).unfocus();
    if (_titleC.text.isNotEmpty && _descC.text.isNotEmpty && dateTime != null) {
      toggleLoading(true);

      await handleScheduleNotification();

      var currentUser = FirebaseAuth.instance.currentUser;

      await _dataBaseServices.addData(
          _titleC.text, _descC.text, dateTime!, currentUser!);

      showAlertDialog(context, 'Success', 'Note Added and Scheduled');

      toggleLoading(false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note Added Successfully'),
        ),
      );

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    } else {
      showAlertDialog(context, 'Error', 'Please Input all field');
    }
  }

  @override
  Widget build(BuildContext context) {
    const textStyleBold =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

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
              'Add New Note',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: handleAddNote,
                child: Icon(
                  Icons.done_outlined,
                  color: Colors.black45,
                  size: 30,
                ),
              )
            ],
          ),
          bottomNavigationBar: CustomBottomBarNotes(scheduleOnTap: () {
            DatePicker.showDateTimePicker(
              context,
              showTitleActions: true,
              minTime: DateTime.now(),
              maxTime: DateTime(2022, 12, 31),
              // onChanged: (date) {
              //   print('change $date');
              // },
              onConfirm: onConfirmDateTime,
              currentTime: DateTime.now(),
              locale: LocaleType.en,
            );
          }),
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
                                : Container(),
                          ),

                          //
                          Container(
                            height: MediaQuery.of(context).size.height * 0.71,
                            padding: const EdgeInsets.only(top: 6.0),
                            child: TextFormField(
                              controller: _descC,
                              decoration: InputDecoration.collapsed(
                                hintText: "Note Description",
                              ),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "lato",
                                // color: Colors.grey,
                              ),
                              maxLines: 1000,
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

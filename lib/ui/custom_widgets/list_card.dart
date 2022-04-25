import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:research_alert/constants/text_styles.dart';
import 'package:research_alert/core/models/notes_model.dart';

class ListCard extends StatelessWidget {
  final Notes notes;
  final VoidCallback press;
  final VoidCallback onLongPress;

  const ListCard({
    required this.notes,
    required this.press,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    String getFormattedDataTime(DateTime dateTime) {
      final myDateTime =
          DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);

      var formattedDate = DateFormat('dd MMM yyyy  hh:mm a').format(myDateTime);

      return formattedDate;
    }

    return InkWell(
      onTap: press,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
        child: SizedBox(
          height: 100,
          child: Card(
            elevation: 2,
            color: Color(0xff86C6F4),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notes.title,
                    style: titleTextStyle,
                  ),
                  SizedBox(height: 5),
                  Flexible(
                    child: Text(
                      notes.desc,
                      style: descTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        getFormattedDataTime(notes.createdAt.toDate()),
                        style: timeTextStyle,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

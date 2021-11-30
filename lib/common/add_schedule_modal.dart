import 'package:flutter/material.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/screens/schedule_create/schedule_create.dart';
import 'package:pets/screens/schedule_create/tasks/notes_tabs.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:provider/provider.dart';

/// showModalBottomSheet wrapped in this widget
void showCustomModalAtBottom(BuildContext context) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (context) {
      void pushToCreateSchedule(int index) {
        if (context.read<UserProvider>().getUserInfo.isMinor) {
          showToast(
              'You are Minor. A Minor cannot perform this Task.', context);
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ScheduleCreate(
              screenIndex: index,
              isFromCreateTask: true,
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(
                  "Add Reminder",
                  style: Theme.of(context).textTheme.headline6,
                ),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  logEvent(ScreenName.clickAddReminder, isEvent: true);
                  Navigator.of(context).pop();
                  pushToCreateSchedule(0);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(
                  "Add Task / Event",
                  style: Theme.of(context).textTheme.headline6,
                ),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.task,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  logEvent(ScreenName.clickAddTask, isEvent: true);
                  Navigator.of(context).pop();
                  pushToCreateSchedule(1);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(
                  "Add Notes",
                  style: Theme.of(context).textTheme.headline6,
                ),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  logEvent(ScreenName.clickAddNotes, isEvent: true);
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return NoteTabs();
                  }));
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

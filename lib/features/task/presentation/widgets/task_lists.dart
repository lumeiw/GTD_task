import 'package:flutter/material.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';

class TaskDropdownLists {
  static List<PopupMenuItem<TaskFlag>> getFlagMenuItems(Color textColor) {
    return TaskFlag.values.map((flag) {
      IconData icon;

      switch (flag) {
        case TaskFlag.priority:
          icon = Icons.warning;
          break;
        case TaskFlag.next:
          icon = Icons.check_circle;
          break;
        case TaskFlag.blocked:
          icon = Icons.block;
          break;
        case TaskFlag.recurring:
          icon = Icons.loop;
          break;
        case TaskFlag.delegated:
          icon = Icons.assignment_turned_in;
          break;
        default:
          icon = Icons.flag;
      }

      return PopupMenuItem(
        value: flag,
        child: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 8),
            Text(
              flag.toString().split('.').last,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      );
    }).toList();
  }

  static List<PopupMenuItem<TaskDuration>> getDurationMenuItems(
      Color textColor) {
    return TaskDuration.values.map((duration) {
      IconData icon;
      switch (duration) {
        case TaskDuration.veryShort:
          icon = Icons.flash_on;
          break;
        case TaskDuration.short:
          icon = Icons.timer;
          break;
        case TaskDuration.medium:
          icon = Icons.timer_3;
          break;
        case TaskDuration.long:
          icon = Icons.access_time;
          break;
        case TaskDuration.veryLong:
          icon = Icons.hourglass_full;
          break;
        case TaskDuration.undefined:
          icon = Icons.help_outline;
          break;
      }

      return PopupMenuItem(
        value: duration,
        child: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 8),
            Text(
              duration.display,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      );
    }).toList();
  }
}

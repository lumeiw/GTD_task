import 'package:flutter/material.dart';
import 'package:gtd_task/features/task/domain/enums/task_flag_enum.dart';
import 'package:gtd_task/features/task/domain/enums/task_duration_enum.dart';

class TaskDropdownLists {
  static IconData getIconForFlag(TaskFlag flag) {
    switch (flag) {
      case TaskFlag.priority:
        return Icons.warning;
      case TaskFlag.next:
        return Icons.check_circle;
      case TaskFlag.blocked:
        return Icons.block;
      // case TaskFlag.recurring:
        // return Icons.loop;
      case TaskFlag.delegated:
        return Icons.assignment_turned_in;
      default:
        return Icons.flag;
    }
  }

  static IconData getIconForDuration(TaskDuration duration) {
    switch (duration) {
      case TaskDuration.short:
        return Icons.timer;
      case TaskDuration.medium:
        return Icons.timer_3;
      case TaskDuration.long:
        return Icons.access_time;
      case TaskDuration.veryLong:
        return Icons.hourglass_full;
      default:
        return Icons.help_outline;
    }
  }

  static List<PopupMenuItem<TaskFlag>> getFlagMenuItems(Color textColor) {
    return TaskFlag.values.map((flag) {
      return PopupMenuItem(
        value: flag,
        child: Row(
          children: [
            Icon(getIconForFlag(flag), color: textColor),
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
      return PopupMenuItem(
        value: duration,
        child: Row(
          children: [
            Icon(getIconForDuration(duration), color: textColor),
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

import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_task/core/router/app_router.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzData;

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    tzData.initializeTimeZones();
    if (Platform.isAndroid || Platform.isIOS) {
      final String timeZoneName =
          await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } else {
      tz.setLocalLocation(tz.getLocation('Asia/Yekaterinburg'));
    }

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettingsWindows = WindowsInitializationSettings(
      appName: 'TaskMe',
      appUserModelId: 'TaskMe',
      guid: 'aa0d7ab7-759f-4923-ad1d-fa7a3f49ea90',
      iconPath: 'windows/runner/resources/app_icon.ico',
    );

    const initSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      windows: initializationSettingsWindows,
    );

    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _isInitialized = true;
  }

  void _onNotificationTap(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    AppRouter.navigatorKey.currentState?.context.go('/task-list-screen/inbox');
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        channelDescription: 'description',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      windows: WindowsNotificationDetails(),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }

  Future<void> scheduleMorningAndEveningNotification({
    required int idMorning,
    required int idEvening,
    required String title,
    required String body,
    required DateTime taskDate,
  }) async {
    final morningTime = tz.TZDateTime(
      tz.local,
      taskDate.year,
      taskDate.month,
      taskDate.day,
      8,
      0,
    );

    final eveningTime = tz.TZDateTime(
      tz.local,
      taskDate.year,
      taskDate.month,
      taskDate.day,
      20,
      0,
    );

    if (Platform.isAndroid) {
      await notificationsPlugin.zonedSchedule(
        idMorning,
        'Утро: $title',
        body,
        morningTime,
        notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      await notificationsPlugin.zonedSchedule(
        idEvening,
        'Вечер: $title',
        'Вы выполнили задачу? $body',
        eveningTime,
        notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } else if (Platform.isIOS || Platform.isWindows) {
      await notificationsPlugin.zonedSchedule(
        idMorning,
        'Утро: $title',
        body,
        morningTime,
        notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      await notificationsPlugin.zonedSchedule(
        idEvening,
        'Вечер: $title',
        'Вы выполнили задачу? $body',
        eveningTime,
        notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelTaskNotifications(int idMorning, int idEvening) async {
    await notificationsPlugin.cancel(idMorning);
    await notificationsPlugin.cancel(idEvening);
  }
}

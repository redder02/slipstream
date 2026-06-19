import 'package:workmanager/workmanager.dart';

class SchedulerService {

  static Future<void> stop() async {
    await Workmanager().cancelAll();
  }

  static Future<void> start(
      Duration duration) async {

    await Workmanager().cancelAll();

    await Workmanager().registerPeriodicTask(
      "wallpaper_task",
      "change_wallpaper",

      frequency: duration,

      existingWorkPolicy:
          ExistingWorkPolicy.replace,
    );
  }
}
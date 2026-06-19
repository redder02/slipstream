import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

    print("BACKGROUND WALLPAPER CHANGE");

    // we'll implement actual wallpaper changing later

    return Future.value(true);
  });
}
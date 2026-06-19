import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class WallpaperSetter {
  static const MethodChannel _channel =
      MethodChannel('slipstream/wallpaper');

  static Future<bool> setWallpaper({
    required String imageUrl,
    required String target,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(imageUrl),
      );

      if (response.statusCode != 200) {
        return false;
      }

      final tempDir =
          await getTemporaryDirectory();

      final file = File(
        '${tempDir.path}/slipstream_wallpaper.jpg',
      );

      await file.writeAsBytes(
        response.bodyBytes,
      );

      final result =
          await _channel.invokeMethod(
        'setWallpaper',
        {
          'path': file.path,
          'target': target,
        },
      );

      return result == true;
    } catch (e) {
        print("WALLPAPER ERROR: $e");
        return false;
    }
  }
}
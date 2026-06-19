import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/wallpaper.dart';

class WallpaperService {
  static const metadataUrl =
      'https://raw.githubusercontent.com/redder02/slipstream-assets/main/metadata.json';

  Future<List<Wallpaper>> fetchWallpapers() async {
    final response =
        await http.get(Uri.parse(metadataUrl));

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load wallpapers',
      );
    }

    final data =
        jsonDecode(response.body);

    final wallpapers = data['images'] as List;

    final safeImages =
        wallpapers.take(900).toList();

    return safeImages
        .map(
          (item) => Wallpaper.fromJson(item),
        )
        .toList();

    // final safeImages = images.take(900).toList();

    return wallpapers
        .map(
          (item) => Wallpaper.fromJson(item),
        )
        .toList();
  }
}

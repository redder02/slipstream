import 'dart:math';
import 'package:flutter/material.dart';

import '../models/wallpaper.dart';
class WallpaperCache {
  final List<Wallpaper> wallpapers;

  int currentIndex = 0;

  WallpaperCache(this.wallpapers);

  Wallpaper get current =>
      wallpapers[currentIndex];

  Wallpaper get next =>
      wallpapers[
          (currentIndex + 1) %
              wallpapers.length];

  Wallpaper get previous =>
      wallpapers[
          (currentIndex - 1 +
                  wallpapers.length) %
              wallpapers.length];

  void shuffleStart() {
    currentIndex =
        Random().nextInt(
      wallpapers.length,
    );
  }

  void moveNext() {
    currentIndex =
        (currentIndex + 1) %
            wallpapers.length;
  }

  void movePrevious() {
    currentIndex =
        (currentIndex - 1 +
                wallpapers.length) %
            wallpapers.length;
  }

  Future<void> preload(
    BuildContext context,
  ) async {
    final futures = <Future>[];

    for (int i = -7; i <= 7; i++) {
      final index =
          (currentIndex + i +
                  wallpapers.length) %
              wallpapers.length;

      futures.add(
        precacheImage(
          NetworkImage(
            wallpapers[index].url,
          ),
          context,
        ),
      );
    }

    await Future.wait(futures);
  }
}

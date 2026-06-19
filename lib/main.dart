import 'package:flutter/material.dart';

import 'models/wallpaper.dart';
import 'services/wallpaper_cache.dart';
import 'services/wallpaper_service.dart';

void main() {
  runApp(const SlipstreamApp());
}

class SlipstreamApp extends StatelessWidget {
  const SlipstreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Slipstream',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  final WallpaperService service =
      WallpaperService();

  WallpaperCache? cache;

  bool loading = true;

  String target = "Both";
  int intervalHours = 3;

  @override
  void initState() {
    super.initState();
    loadWallpapers();
  }

  Future<void> loadWallpapers() async {
    try {
      final wallpapers =
          await service.fetchWallpapers();

      final wallpaperCache =
          WallpaperCache(wallpapers);

      wallpaperCache.shuffleStart();

      setState(() {
        cache = wallpaperCache;
        loading = false;
      });

      WidgetsBinding.instance
          .addPostFrameCallback((_) {
        cache?.preload(context);
      });
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        loading = false;
      });
    }
  }

  void nextWallpaper() {
    if (cache == null) return;

    setState(() {
      cache!.moveNext();
    });

    cache!.preload(context);
  }

  void previousWallpaper() {
    if (cache == null) return;

    setState(() {
      cache!.movePrevious();
    });

    cache!.preload(context);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (cache == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Failed to load wallpapers",
          ),
        ),
      );
    }

    final Wallpaper wallpaper =
        cache!.current;

    final showDriver =
        wallpaper.drivers !=
            "Unknown Driver";

    final showTeam =
        wallpaper.teams !=
            "Unknown Team";

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),

              const Text(
                "Slipstream",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              const Padding(
                padding:
                    EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Align(
                  alignment:
                      Alignment.centerLeft,
                  child: Text(
                    "Wallpaper Target",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 12,
                ),
                child:
                    SegmentedButton<
                        String>(
                  segments: const [
                    ButtonSegment(
                      value: "Home",
                      label:
                          Text("Home"),
                    ),
                    ButtonSegment(
                      value: "Lock",
                      label:
                          Text("Lock"),
                    ),
                    ButtonSegment(
                      value: "Both",
                      label:
                          Text("Both"),
                    ),
                  ],
                  selected: {target},
                  onSelectionChanged:
                      (value) {
                    setState(() {
                      target =
                          value.first;
                    });
                  },
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                "Change Every",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              SizedBox(
                height: 160,
                child:
                    ListWheelScrollView
                        .useDelegate(
                  itemExtent: 45,
                  perspective:
                      0.004,
                  diameterRatio:
                      1.7,
                  controller:
                      FixedExtentScrollController(
                    initialItem:
                        intervalHours -
                            1,
                  ),
                  onSelectedItemChanged:
                      (index) {
                    setState(() {
                      intervalHours =
                          index + 1;
                    });
                  },
                  childDelegate:
                      ListWheelChildBuilderDelegate(
                    childCount: 24,
                    builder:
                        (context,
                            index) {
                      final hour =
                          index + 1;

                      return Center(
                        child: Text(
                          "$hour h",
                          style:
                              const TextStyle(
                            fontSize:
                                22,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const Spacer(),

              Padding(
                padding:
                    const EdgeInsets
                        .all(20),
                child: Text(
                  "Auto change every $intervalHours hour${intervalHours > 1 ? 's' : ''}",
                  textAlign:
                      TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd:
            (details) {
          if (details
                  .primaryVelocity ==
              null) {
            return;
          }

          if (details
                  .primaryVelocity! <
              0) {
            nextWallpaper();
          } else {
            previousWallpaper();
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedSwitcher(
              duration:
                  const Duration(
                milliseconds: 350,
              ),
              child: Image.network(
                wallpaper.url,
                key: ValueKey(
                  wallpaper.id,
                ),
                fit: BoxFit.cover,
              ),
            ),

            Container(
              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  begin:
                      Alignment
                          .topCenter,
                  end: Alignment
                      .bottomCenter,
                  colors: [
                    Colors.black
                        .withOpacity(
                            0.05),
                    Colors.black
                        .withOpacity(
                            0.20),
                    Colors.black
                        .withOpacity(
                            0.85),
                  ],
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      Builder(
                        builder:
                            (context) {
                          return IconButton(
                            onPressed:
                                () {
                              Scaffold.of(
                                      context)
                                  .openDrawer();
                            },
                            icon:
                                const Icon(
                              Icons.menu,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const Spacer(),

                  Container(
                    margin:
                        const EdgeInsets
                            .all(20),
                    padding:
                        const EdgeInsets
                            .all(20),
                    decoration:
                        BoxDecoration(
                      color: Colors
                          .black
                          .withOpacity(
                              0.30),
                      borderRadius:
                          BorderRadius
                              .circular(
                                  24),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      mainAxisSize:
                          MainAxisSize
                              .min,
                      children: [
                        if (showDriver)
                          Text(
                            wallpaper
                                .drivers,
                            style:
                                const TextStyle(
                              fontSize:
                                  26,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                        if (showTeam)
                          Padding(
                            padding:
                                const EdgeInsets
                                    .only(
                              top: 6,
                            ),
                            child:
                                Text(
                              wallpaper
                                  .teams,
                              style:
                                  const TextStyle(
                                fontSize:
                                    18,
                                color: Colors
                                    .white70,
                              ),
                            ),
                          ),

                        if (!showDriver &&
                            !showTeam)
                          const Text(
                            "Formula One",
                            style:
                                TextStyle(
                              fontSize:
                                  24,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                        const SizedBox(
                            height:
                                18),

                        SizedBox(
                          width: double
                              .infinity,
                          height: 56,
                          child:
                              ElevatedButton(
                            onPressed:
                                () {
                              ScaffoldMessenger.of(
                                      context)
                                  .showSnackBar(
                                const SnackBar(
                                  content:
                                      Text(
                                    "Wallpaper setting coming next",
                                  ),
                                ),
                              );
                            },
                            child:
                                const Text(
                              "Apply Wallpaper",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

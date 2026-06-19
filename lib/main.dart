import 'package:flutter/material.dart';
import 'services/wallpaper_setter.dart';
import 'models/wallpaper.dart';
import 'services/wallpaper_cache.dart';
import 'services/wallpaper_service.dart';
import 'package:workmanager/workmanager.dart';
import 'background/wallpaper_worker.dart';
import 'services/scheduler_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

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
  String changeMode = "fixed";

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
                "Auto Change",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Column(
                  children: [

                    ListTile(
                      title: const Text(
                        "Fixed Wallpaper",
                      ),
                      leading: Radio<String>(
                        value: "fixed",
                        groupValue: changeMode,
                        onChanged: (value) async {
                          setState(() {
                            changeMode = value!;
                          });

                          await SchedulerService.stop();
                        },
                      ),
                    ),

                    ListTile(
                      title: const Text(
                        "Every 15 Minutes",
                      ),
                      leading: Radio<String>(
                        value: "15m",
                        groupValue: changeMode,
                        onChanged: (value) async {
                          setState(() {
                            changeMode = value!;
                          });

                          await SchedulerService.start(
                            const Duration(
                              minutes: 15,
                            ),
                          );
                        },
                      ),
                    ),

                    ListTile(
                      title: const Text(
                        "Every 30 Minutes",
                      ),
                      leading: Radio<String>(
                        value: "30m",
                        groupValue: changeMode,
                        onChanged: (value) async {
                          setState(() {
                            changeMode = value!;
                          });

                          await SchedulerService.start(
                            const Duration(
                              minutes: 30,
                            ),
                          );
                        },
                      ),
                    ),

                    ListTile(
                      title: const Text(
                        "Every 1 Hour",
                      ),
                      leading: Radio<String>(
                        value: "1h",
                        groupValue: changeMode,
                        onChanged: (value) async {
                          setState(() {
                            changeMode = value!;
                          });

                          await SchedulerService.start(
                            const Duration(
                              hours: 1,
                            ),
                          );
                        },
                      ),
                    ),

                    ListTile(
                      title: const Text(
                        "Every 3 Hours",
                      ),
                      leading: Radio<String>(
                        value: "3h",
                        groupValue: changeMode,
                        onChanged: (value) async {
                          setState(() {
                            changeMode = value!;
                          });

                          await SchedulerService.start(
                            const Duration(
                              hours: 3,
                            ),
                          );
                        },
                      ),
                    ),

                    ListTile(
                      title: const Text(
                        "Every 6 Hours",
                      ),
                      leading: Radio<String>(
                        value: "6h",
                        groupValue: changeMode,
                        onChanged: (value) async {
                          setState(() {
                            changeMode = value!;
                          });

                          await SchedulerService.start(
                            const Duration(
                              hours: 6,
                            ),
                          );
                        },
                      ),
                    ),

                    ListTile(
                      title: const Text(
                        "Every 12 Hours",
                      ),
                      leading: Radio<String>(
                        value: "12h",
                        groupValue: changeMode,
                        onChanged: (value) async {
                          setState(() {
                            changeMode = value!;
                          });

                          await SchedulerService.start(
                            const Duration(
                              hours: 12,
                            ),
                          );
                        },
                      ),
                    ),

                    ListTile(
                      title: const Text(
                        "Every 24 Hours",
                      ),
                      leading: Radio<String>(
                        value: "24h",
                        groupValue: changeMode,
                        onChanged: (value) async {
                          setState(() {
                            changeMode = value!;
                          });

                          await SchedulerService.start(
                            const Duration(
                              hours: 24,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              

              if (changeMode == "fixed") ...[
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Wallpaper remains fixed until changed manually.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              if (changeMode == "unlock") ...[
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Wallpaper changes every time the phone is unlocked.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              const Spacer(),
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
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.wallpaper),
                            label: const Text(
                              "Apply Wallpaper",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () async {
                              final wallpaper = cache!.current;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Applying wallpaper...',
                                  ),
                                ),
                              );

                              final success =
                                  await WallpaperSetter.setWallpaper(
                                imageUrl: wallpaper.url,
                                target: target,
                              );

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Wallpaper Applied!'
                                        : 'Failed to apply wallpaper',
                                  ),
                                ),
                              );
                            },
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

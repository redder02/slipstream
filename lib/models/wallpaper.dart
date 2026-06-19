class Wallpaper {
  final int id;
  final String filename;
  final String url;
  final String teams;
  final String drivers;
  final String credit;

  Wallpaper({
    required this.id,
    required this.filename,
    required this.url,
    required this.teams,
    required this.drivers,
    required this.credit,
  });

  factory Wallpaper.fromJson(
    Map<String, dynamic> json,
  ) {
    return Wallpaper(
      id: json['id'] ?? 0,
      filename: json['filename'] ?? '',
      url: (json['url'] ?? '')
          .replaceFirst(
            'https://github.com/redder02/slipstream-assets/tree/main/',
            'https://raw.githubusercontent.com/redder02/slipstream-assets/main/',
          ),
      teams: json['teams'] ?? 'Unknown Team',
      drivers: json['drivers'] ?? 'Unknown Driver',
      credit: json['credit'] ?? '',
    );
  }
}
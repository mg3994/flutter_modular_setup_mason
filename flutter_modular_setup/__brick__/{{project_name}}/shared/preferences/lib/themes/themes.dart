import 'package:flutter/material.dart';

const List<Color> appThemeSeedColorConstants = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.pink,
];

ThemeData appLightTheme(Color seedColor) => _appTheme(seedColor, false);

ThemeData appDarkTheme(Color seedColor) => _appTheme(seedColor, true);

ThemeData _appTheme(Color seedColor, bool isDarkThemeMode) {
  final baseTheme = isDarkThemeMode
      ? ThemeData.dark(useMaterial3: true)
      : ThemeData.light(useMaterial3: true);
  return baseTheme.copyWith(
    brightness: isDarkThemeMode ? Brightness.dark : Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
    scaffoldBackgroundColor:
        isDarkThemeMode ? const Color(0xFF303030) : const Color(0xFFf5f5f5),
    bannerTheme: isDarkThemeMode
        ? const MaterialBannerThemeData(backgroundColor: Colors.black)
        : const MaterialBannerThemeData(backgroundColor: Colors.white),
    iconTheme: IconThemeData(
      color: isDarkThemeMode ? Colors.white70 : Colors.black,
    ),
    textTheme: TextTheme(
      bodySmall:
          TextStyle(color: isDarkThemeMode ? Colors.white70 : Colors.black),
      bodyMedium:
          TextStyle(color: isDarkThemeMode ? Colors.white70 : Colors.black),
    ),
    extensions: <AntinnaAppTheme>[
      AntinnaAppTheme(isDarkThemeMode: isDarkThemeMode, seedColor: seedColor),
    ],
  );
}

final class AntinnaAppTheme extends ThemeExtension<AntinnaAppTheme> {
  final bool isDarkThemeMode;
  final Color seedColor;
  final Color appColor0;
  final Color appColor1;
  final Color appColor2;

  AntinnaAppTheme({
    required this.isDarkThemeMode,
    required this.seedColor,
  })  : appColor0 = _adjustColor(seedColor, isDarkThemeMode, 50, 10),
        appColor1 = _adjustColor(seedColor, isDarkThemeMode, 50, 10),
        appColor2 = _adjustColor(seedColor, isDarkThemeMode, 50, 10);

  static Color _adjustColor(
      Color color, bool isDark, int darkValue, int lightValue) {
    return isDark ? color.withAlpha(darkValue) : color.withAlpha(lightValue);
  }

  static AntinnaAppTheme of(BuildContext context) {
    return Theme.of(context).extension<AntinnaAppTheme>()!;
  }

  @override
  AntinnaAppTheme copyWith({
    bool? isDarkThemeMode,
    Color? seedColor,
    Color? appColor0,
    Color? appColor1,
    Color? appColor2,
  }) {
    return AntinnaAppTheme(
      isDarkThemeMode: isDarkThemeMode ?? this.isDarkThemeMode,
      seedColor: seedColor ?? this.seedColor,
    );
  }

  @override
  AntinnaAppTheme lerp(
      covariant ThemeExtension<AntinnaAppTheme> other, double t) {
    if (other is! AntinnaAppTheme) return this;
    return AntinnaAppTheme(
      isDarkThemeMode: isDarkThemeMode,
      seedColor: Color.lerp(seedColor, other.seedColor, t)!,
    );
  }
}

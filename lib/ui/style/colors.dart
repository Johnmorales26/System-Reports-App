import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278216824),
      surfaceTint: Color(4278216824),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4289130239),
      onPrimaryContainer: Color(4278198053),
      secondary: Color(4283130472),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4291684334),
      onSecondaryContainer: Color(4278525732),
      tertiary: Color(4283784574),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4292665855),
      onTertiaryContainer: Color(4279310903),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294310652),
      onSurface: Color(4279704862),
      onSurfaceVariant: Color(4282337355),
      outline: Color(4285495675),
      outlineVariant: Color(4290758859),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020723),
      inversePrimary: Color(4286829285),
      primaryFixed: Color(4289130239),
      onPrimaryFixed: Color(4278198053),
      primaryFixedDim: Color(4286829285),
      onPrimaryFixedVariant: Color(4278210139),
      secondaryFixed: Color(4291684334),
      onSecondaryFixed: Color(4278525732),
      secondaryFixedDim: Color(4289907666),
      onSecondaryFixedVariant: Color(4281551440),
      tertiaryFixed: Color(4292665855),
      onTertiaryFixed: Color(4279310903),
      tertiaryFixedDim: Color(4290627051),
      onTertiaryFixedVariant: Color(4282205541),
      surfaceDim: Color(4292205533),
      surfaceBright: Color(4294310652),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293915894),
      surfaceContainer: Color(4293521393),
      surfaceContainerHigh: Color(4293192171),
      surfaceContainerHighest: Color(4292797413),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278209110),
      surfaceTint: Color(4278216824),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280844176),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281288268),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4284577919),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4281942369),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4285232021),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294310652),
      onSurface: Color(4279704862),
      onSurfaceVariant: Color(4282074183),
      outline: Color(4283916643),
      outlineVariant: Color(4285758591),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020723),
      inversePrimary: Color(4286829285),
      primaryFixed: Color(4280844176),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278216053),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4284577919),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4282933350),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4285232021),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4283652987),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292205533),
      surfaceBright: Color(4294310652),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293915894),
      surfaceContainer: Color(4293521393),
      surfaceContainerHigh: Color(4293192171),
      surfaceContainerHighest: Color(4292797413),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278199853),
      surfaceTint: Color(4278216824),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4278209110),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4279051563),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4281288268),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4279771454),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4281942369),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294310652),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280100136),
      outline: Color(4282074183),
      outlineVariant: Color(4282074183),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020723),
      inversePrimary: Color(4291294463),
      primaryFixed: Color(4278209110),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278202938),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4281288268),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4279775285),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4281942369),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4280494921),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292205533),
      surfaceBright: Color(4294310652),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293915894),
      surfaceContainer: Color(4293521393),
      surfaceContainerHigh: Color(4293192171),
      surfaceContainerHighest: Color(4292797413),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4286829285),
      surfaceTint: Color(4286829285),
      onPrimary: Color(4278203967),
      primaryContainer: Color(4278210139),
      onPrimaryContainer: Color(4289130239),
      secondary: Color(4289907666),
      onSecondary: Color(4280038457),
      secondaryContainer: Color(4281551440),
      onSecondaryContainer: Color(4291684334),
      tertiary: Color(4290627051),
      onTertiary: Color(4280758093),
      tertiaryContainer: Color(4282205541),
      onTertiaryContainer: Color(4292665855),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279112726),
      onSurface: Color(4292797413),
      onSurfaceVariant: Color(4290758859),
      outline: Color(4287206037),
      outlineVariant: Color(4282337355),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797413),
      inversePrimary: Color(4278216824),
      primaryFixed: Color(4289130239),
      onPrimaryFixed: Color(4278198053),
      primaryFixedDim: Color(4286829285),
      onPrimaryFixedVariant: Color(4278210139),
      secondaryFixed: Color(4291684334),
      onSecondaryFixed: Color(4278525732),
      secondaryFixedDim: Color(4289907666),
      onSecondaryFixedVariant: Color(4281551440),
      tertiaryFixed: Color(4292665855),
      onTertiaryFixed: Color(4279310903),
      tertiaryFixedDim: Color(4290627051),
      onTertiaryFixedVariant: Color(4282205541),
      surfaceDim: Color(4279112726),
      surfaceBright: Color(4281612860),
      surfaceContainerLowest: Color(4278783761),
      surfaceContainerLow: Color(4279704862),
      surfaceContainer: Color(4279968034),
      surfaceContainerHigh: Color(4280625965),
      surfaceContainerHighest: Color(4281349687),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4287158249),
      surfaceTint: Color(4286829285),
      onPrimary: Color(4278196511),
      primaryContainer: Color(4283145389),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4290170838),
      onSecondary: Color(4278262046),
      secondaryContainer: Color(4286354843),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4290890223),
      onTertiary: Color(4278981681),
      tertiaryContainer: Color(4287074227),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279112726),
      onSurface: Color(4294376701),
      onSurfaceVariant: Color(4291022031),
      outline: Color(4288390311),
      outlineVariant: Color(4286285191),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797413),
      inversePrimary: Color(4278210652),
      primaryFixed: Color(4289130239),
      onPrimaryFixed: Color(4278195224),
      primaryFixedDim: Color(4286829285),
      onPrimaryFixedVariant: Color(4278205510),
      secondaryFixed: Color(4291684334),
      onSecondaryFixed: Color(4278195224),
      secondaryFixedDim: Color(4289907666),
      onSecondaryFixedVariant: Color(4280433215),
      tertiaryFixed: Color(4292665855),
      onTertiaryFixed: Color(4278587180),
      tertiaryFixedDim: Color(4290627051),
      onTertiaryFixedVariant: Color(4281152851),
      surfaceDim: Color(4279112726),
      surfaceBright: Color(4281612860),
      surfaceContainerLowest: Color(4278783761),
      surfaceContainerLow: Color(4279704862),
      surfaceContainer: Color(4279968034),
      surfaceContainerHigh: Color(4280625965),
      surfaceContainerHighest: Color(4281349687),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294180095),
      surfaceTint: Color(4286829285),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4287158249),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294180095),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4290170838),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294769407),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4290890223),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279112726),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294180095),
      outline: Color(4291022031),
      outlineVariant: Color(4291022031),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797413),
      inversePrimary: Color(4278202167),
      primaryFixed: Color(4290179327),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4287158249),
      onPrimaryFixedVariant: Color(4278196511),
      secondaryFixed: Color(4292013042),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4290170838),
      onSecondaryFixedVariant: Color(4278262046),
      tertiaryFixed: Color(4293060095),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4290890223),
      onTertiaryFixedVariant: Color(4278981681),
      surfaceDim: Color(4279112726),
      surfaceBright: Color(4281612860),
      surfaceContainerLowest: Color(4278783761),
      surfaceContainerLow: Color(4279704862),
      surfaceContainer: Color(4279968034),
      surfaceContainerHigh: Color(4280625965),
      surfaceContainerHighest: Color(4281349687),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

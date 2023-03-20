import 'package:flowy_infra/colorscheme/colorscheme.dart';
import 'package:flutter/material.dart';

class InfraThemeExtension extends ThemeExtension<InfraThemeExtension> {
  InfraThemeExtension({
    required this.colorScheme,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.titleTextStyle,
    required this.subTitleTextStyle,
    required this.subTitleTextColor,
    required this.hoverBgColor,
    required this.hoverTextColor,
    required this.tooltipBgColor,
    required this.tooltipTextStyle,
  });
  final FlowyColorScheme? colorScheme;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final TextStyle? titleTextStyle;
  final TextStyle? subTitleTextStyle;
  final Color? subTitleTextColor;
  final Color? hoverBgColor;
  final Color? hoverTextColor;
  final Color? tooltipBgColor;
  final TextStyle? tooltipTextStyle;

  @override
  ThemeExtension<InfraThemeExtension> copyWith({
    FlowyColorScheme? colorScheme,
    Color? backgroundColor,
    Color? borderColor,
    Color? iconColor,
    TextStyle? titleTextStyle,
    TextStyle? subTitleTextStyle,
    Color? subTitleTextColor,
    Color? hoverBgColor,
    Color? hoverTextColor,
    Color? tooltipBgColor,
    TextStyle? tooltipTextStyle,
  }) {
    return InfraThemeExtension(
      colorScheme: colorScheme ?? this.colorScheme,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      iconColor: iconColor ?? this.iconColor,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      subTitleTextStyle: subTitleTextStyle ?? this.subTitleTextStyle,
      subTitleTextColor: subTitleTextColor ?? this.subTitleTextColor,
      hoverBgColor: hoverBgColor ?? this.hoverBgColor,
      hoverTextColor: hoverTextColor ?? this.hoverTextColor,
      tooltipBgColor: tooltipBgColor ?? this.tooltipBgColor,
      tooltipTextStyle: tooltipTextStyle ?? this.tooltipTextStyle,
    );
  }

  @override
  ThemeExtension<InfraThemeExtension> lerp(
      ThemeExtension<InfraThemeExtension>? other, double t) {
    if (other is! InfraThemeExtension) {
      return this;
    }
    return InfraThemeExtension(
      colorScheme: colorScheme,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t),
      subTitleTextStyle:
          TextStyle.lerp(subTitleTextStyle, other.subTitleTextStyle, t),
      subTitleTextColor:
          Color.lerp(subTitleTextColor, other.subTitleTextColor, t),
      hoverBgColor: Color.lerp(hoverBgColor, other.hoverBgColor, t),
      hoverTextColor: Color.lerp(hoverTextColor, other.hoverTextColor, t),
      tooltipBgColor: Color.lerp(tooltipBgColor, other.tooltipBgColor, t),
      tooltipTextStyle:
          TextStyle.lerp(tooltipTextStyle, other.tooltipTextStyle, t),
    );
  }

  factory InfraThemeExtension.fromColorSchemeInLigtMode(
          FlowyColorScheme colorScheme) =>
      InfraThemeExtension(
        colorScheme: colorScheme,
        backgroundColor: Color(0xFFF7F8FC),
        borderColor: Color(0xFFF2F2F2),
        //iconColor
        iconColor: colorScheme.main1,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
          fontSize: 12,
        ),
        subTitleTextStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        //subtitle text color
        subTitleTextColor: colorScheme.main1,
        hoverBgColor: Color(0xFFE0F8FF),
        hoverTextColor: Color(0xFF333333),
        tooltipBgColor: Color(0xFFE0F8FF),
        tooltipTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
          fontSize: 12,
        ),
      );
  factory InfraThemeExtension.fromColorSchemeInDarkMode(
          FlowyColorScheme colorScheme) =>
      InfraThemeExtension(
        colorScheme: colorScheme,
        backgroundColor: Color(0xFF232B38),
        borderColor: Color(0xFFF2F2F2),
        //!!
        //It is mian1 in the light mode
        //It can be set to different color name in dark mode
        iconColor: colorScheme.green,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 12,
        ),
        subTitleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        //!! subtitle text color
        subTitleTextColor: colorScheme.green,
        hoverBgColor: Color(0xFF363D49),
        hoverTextColor: Color(0xFF131720),
        tooltipBgColor: Color(0xFF00BCF0),
        tooltipTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xFF131720),
          fontSize: 12,
        ),
      );
}

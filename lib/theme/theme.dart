import 'package:flutter/material.dart';
import 'package:note_ai/product/project_colors.dart';

ThemeData appTheme = ThemeData.dark().copyWith(
  //SCAFFOLD THEME
  scaffoldBackgroundColor: ProjectColors.mainBackgroundColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ProjectColors.whiteColor,
    primary: ProjectColors.whiteColor,
  ),
  //APPBAR THEME
  appBarTheme: const AppBarTheme(
    backgroundColor: ProjectColors.mainBackgroundColor,
    foregroundColor: ProjectColors.firstColor,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: ProjectColors.firstColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  //CARD THEME
  cardColor: ProjectColors.cardColor,
  cardTheme: const CardTheme(
    shadowColor: Colors.transparent,
    elevation: 0,
  ),
  //TEXT THEME
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: ProjectColors.whiteColor),
    bodyMedium: TextStyle(color: ProjectColors.whiteColor),
  ),
  //FLOATING ACTION BUTTON THEME
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: ProjectColors.cardColor,
    foregroundColor: ProjectColors.firstColor,
  ),
  //ELEVATED BUTTON THEME
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey;
        }
        return ProjectColors.buttonColor;
      }),
      foregroundColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return ProjectColors.whiteColor;
        }
        return ProjectColors.firstColor;
      }),
      textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      minimumSize:
          MaterialStateProperty.all<Size>(const Size(double.infinity, 50)),
      shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
    ),
  ),
  //POPUP MENU THEME
  popupMenuTheme: const PopupMenuThemeData(
    color: ProjectColors.cardColor,
  ),
  // ICON THEME
  iconTheme: const IconThemeData(color: ProjectColors.whiteColor),
  // DIALOG THEME
  dialogTheme: const DialogTheme(
    backgroundColor: ProjectColors.cardColor,
    titleTextStyle: TextStyle(
        color: ProjectColors.firstColor,
        fontSize: 20,
        fontWeight: FontWeight.bold),
    contentTextStyle: TextStyle(color: ProjectColors.firstColor),
  ),
  //TEXT BUTTON THEME
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: ProjectColors.whiteColor,
      backgroundColor: Colors.transparent,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  //INPUT DECORATION THEME
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: ProjectColors.textInputColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    hintStyle: const TextStyle(
      color: ProjectColors.whiteColor,
      fontWeight: FontWeight.bold,
    ),
  ),
);

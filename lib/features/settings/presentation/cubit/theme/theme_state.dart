import 'package:flutter/material.dart';

sealed class ThemeState {}

class ThemeInitial extends ThemeState {}

class ThemeLoading extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final ThemeData themeData;

  ThemeLoaded(this.themeData);
}

class ThemeError extends ThemeState {
  final String message;

  ThemeError(this.message);
}

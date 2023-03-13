part of 'theme_cubit.dart';

abstract class ThemeState extends Equatable {
  final IconData themeIcon;
  const ThemeState(this.themeIcon);

  @override
  List<Object?> get props => [themeIcon];
}

class ThemeDark extends ThemeState {
  const ThemeDark(super.themeIcon);

  @override
  List<Object?> get props => [];
}

class ThemeLight extends ThemeState {
  const ThemeLight(super.themeIcon);

  @override
  List<Object?> get props => [];
}
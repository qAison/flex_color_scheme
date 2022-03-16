import 'package:flutter/material.dart';

import 'color_card.dart';

/// Draw a number of boxes showing the colors of key theme color properties
/// in the ColorScheme of the inherited ThemeData and some of its key color
/// properties.
///
/// This widget is just used so we can visually see the active theme colors
/// in the examples and their used FlexColorScheme based themes.
///
/// It also show some warning labels when using surface branding that is too
/// strong and makes the surface require reverse contrasted text in relation to
/// text normally associated with the active theme mode.
///
/// These are all Flutter "Universal" Widgets that only depends on the SDK and
/// all the Widgets in this file be dropped into any application. They are
/// however not so generally reusable.
class ShowThemeDataColors extends StatelessWidget {
  const ShowThemeDataColors({Key? key, this.onBackgroundColor})
      : super(key: key);

  /// The color of the background the color widget are being drawn on.
  ///
  /// Some of the theme colors may have semi transparent fill color. To compute
  /// a legible text color for the sum when it shown on a background color, we
  /// need to alpha merge it with background and we need the exact background
  /// color it is drawn on for that. If not passed in from parent, it is
  /// assumed to be drawn on card color, which usually is close enough.
  final Color? onBackgroundColor;

  // Return true if the color is light, meaning it needs dark text for contrast.
  static bool _isLight(final Color color) =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.light;

  // Return true if the color is dark, meaning it needs light text for contrast.
  static bool _isDark(final Color color) =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.dark;

  // On color used when a theme color property does not have a theme onColor.
  static Color _onColor(final Color color, final Color background) =>
      _isLight(Color.alphaBlend(color, background))
          ? Colors.black
          : Colors.white;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = colorScheme.brightness == Brightness.dark;

    // Grab the card border from the theme card shape
    ShapeBorder? border = theme.cardTheme.shape;
    // If we had one, copy in a border side to it.
    if (border is RoundedRectangleBorder) {
      border = border.copyWith(
        side: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      );
    } else {
      // If border was null, make one matching Card default, but with border
      // side, if it was not null, we leave it as it was.
      border ??= RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        side: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      );
    }

    // Get effective background color.
    final Color background =
        onBackgroundColor ?? theme.cardTheme.color ?? theme.cardColor;

    // Warning label for scaffold background when it uses to much blend.
    final String scaffoldTooHigh = isDark
        ? _isLight(theme.scaffoldBackgroundColor)
            ? '\nTOO HIGH'
            : ''
        : _isDark(theme.scaffoldBackgroundColor)
            ? '\nTOO HIGH'
            : '';
    // Warning label for scaffold background when it uses to much blend.
    final String surfaceTooHigh = isDark
        ? _isLight(theme.colorScheme.surface)
            ? '\nTOO HIGH'
            : ''
        : _isDark(theme.colorScheme.surface)
            ? '\nTOO HIGH'
            : '';

    // Warning label for scaffold background when it uses to much blend.
    final String backTooHigh = isDark
        ? _isLight(theme.colorScheme.background)
            ? '\nTOO HIGH'
            : ''
        : _isDark(theme.colorScheme.background)
            ? '\nTOO HIGH'
            : '';

    // Wrap this widget branch in a custom theme where card has a border outline
    // if it did not have one, but retains in ambient themed border radius.
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme.of(context).copyWith(
          elevation: 0,
          shape: border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'ThemeData Colors',
              style: theme.textTheme.titleMedium,
            ),
          ),
          Text('To be deprecated in Flutter SDK',
              style: theme.textTheme.bodyMedium!
                  .copyWith(color: theme.textTheme.bodySmall!.color)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              ColorCard(
                label: 'Primary\nColor',
                color: theme.primaryColor,
                textColor: _onColor(theme.primaryColor, background),
              ),
              ColorCard(
                label: 'Primary\nDark',
                color: theme.primaryColorDark,
                textColor: _onColor(theme.primaryColorDark, background),
              ),
              ColorCard(
                label: 'Primary\nLight',
                color: theme.primaryColorLight,
                textColor: _onColor(theme.primaryColorLight, background),
              ),
              ColorCard(
                label: 'Secondary\nHeader',
                color: theme.secondaryHeaderColor,
                textColor: _onColor(theme.secondaryHeaderColor, background),
              ),
              ColorCard(
                label: 'Toggleable\nActive',
                color: theme.toggleableActiveColor,
                textColor: _onColor(theme.toggleableActiveColor, background),
              ),
              ColorCard(
                label: 'Bottom\nAppBar',
                color: theme.bottomAppBarColor,
                textColor: _onColor(theme.bottomAppBarColor, background),
              ),
              ColorCard(
                label: 'Error\nColor',
                color: theme.errorColor,
                textColor: colorScheme.onError,
              ),
              ColorCard(
                label: 'Canvas$backTooHigh',
                color: theme.canvasColor,
                textColor: colorScheme.onBackground,
              ),
              ColorCard(
                label: 'Card$surfaceTooHigh',
                color: theme.cardColor,
                textColor: colorScheme.onSurface,
              ),
              ColorCard(
                label: 'Scaffold\nBackground$scaffoldTooHigh',
                color: theme.scaffoldBackgroundColor,
                textColor: _onColor(theme.scaffoldBackgroundColor, background),
              ),
              ColorCard(
                label: 'Dialog',
                color: theme.dialogBackgroundColor,
                textColor: _onColor(theme.dialogBackgroundColor, background),
              ),
              ColorCard(
                label: 'Indicator\nColor',
                color: theme.indicatorColor,
                textColor: _onColor(theme.indicatorColor, background),
              ),
              ColorCard(
                label: 'Divider\nColor',
                color: theme.dividerColor,
                textColor: _onColor(theme.dividerColor, background),
              ),
              ColorCard(
                label: 'Disabled\nColor',
                color: theme.disabledColor,
                textColor: _onColor(theme.disabledColor, background),
              ),
              ColorCard(
                label: 'Hover\nColor',
                color: theme.hoverColor,
                textColor: _onColor(theme.hoverColor, background),
              ),
              ColorCard(
                label: 'Focus\nColor',
                color: theme.focusColor,
                textColor: _onColor(theme.focusColor, background),
              ),
              ColorCard(
                label: 'Highlight\nColor',
                color: theme.highlightColor,
                textColor: _onColor(theme.highlightColor, background),
              ),
              ColorCard(
                label: 'Splash\nColor',
                color: theme.splashColor,
                textColor: _onColor(theme.splashColor, background),
              ),
              ColorCard(
                label: 'Shadow\nColor',
                color: theme.shadowColor,
                textColor: _onColor(theme.shadowColor, background),
              ),
              ColorCard(
                label: 'Hint\nColor',
                color: theme.hintColor,
                textColor: _onColor(theme.hintColor, background),
              ),
              ColorCard(
                label: 'Selected\nRow',
                color: theme.selectedRowColor,
                textColor: _onColor(theme.selectedRowColor, background),
              ),
              ColorCard(
                label: 'Unselected\nWidget',
                color: theme.unselectedWidgetColor,
                textColor: _onColor(theme.unselectedWidgetColor, background),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../shared/all_shared_imports.dart';

// -----------------------------------------------------------------------------
// Home Page for EXAMPLE 5)
//
// The content of the HomePage below is not relevant for using FlexColorScheme
// based application theming. The critical parts are in the above MaterialApp
// theme definitions. The HomePage contains UI to visually show what the
// defined example looks like in an application and with commonly used Widgets.
// -----------------------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ThemeController controller;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController scrollController;

  // The reason for example 5 using a stateful widget is that it holds the
  // state of the dummy side menu/rail locally. However, all state for the
  // application theme are in this example also held by the stateful MaterialApp
  // widget, and values are passed in and changed via ValueChanged callbacks.
  double _menuWidth = AppConst.expandWidth;
  bool _isExpanded = true;

  // The state for the system navbar style and divider usage is local as it is
  // is only used by the AnnotatedRegion, not by FlexThemeData.
  //
  // Used to control system navbar style via an AnnotatedRegion.
  FlexSystemNavBarStyle _navBarStyle = FlexSystemNavBarStyle.background;
  // Used to control if we have a top divider on the system navigation bar.
  bool _useNavDivider = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // FlexSystemNavBarStyle enum to widget map, used in a CupertinoSegment.
  static const Map<FlexSystemNavBarStyle, Widget> _systemNavBar =
      <FlexSystemNavBarStyle, Widget>{
    FlexSystemNavBarStyle.system: Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        'System',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    ),
    FlexSystemNavBarStyle.surface: Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        'Surface',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    ),
    FlexSystemNavBarStyle.background: Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        'Back\u{00AD}ground',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    ),
    FlexSystemNavBarStyle.scaffoldBackground: Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        'Scaffold\nback\u{00AD}ground',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    ),
    FlexSystemNavBarStyle.transparent: Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        'Trans\u{00AD}parent',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double topPadding = media.padding.top;
    final double bottomPadding = media.padding.bottom;
    final bool menuAvailable = media.size.width >= AppConst.desktopBreakpoint;

    final ThemeData theme = Theme.of(context);
    final bool isLight = theme.brightness == Brightness.light;
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final TextStyle headline4 = textTheme.headline4!;

    // Give the width of the side panel some automatic adaptive behavior and
    // make it rail sized when there is not enough room for a menu, even if
    // menu size is requested.
    if (!menuAvailable) {
      _menuWidth = AppConst.collapseWidth;
    }
    if (menuAvailable && !_isExpanded) {
      _menuWidth = AppConst.collapseWidth;
    }
    if (menuAvailable && _isExpanded) {
      _menuWidth = AppConst.expandWidth;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // FlexColorScheme contains a helper that can be use to theme
      // the system navigation bar using an AnnotatedRegion. Without this
      // page wrapper the system navigation bar in Android will not change
      // theme color as we change themes for the page. This is a
      // Flutter "feature", but with this annotated region we can have the
      // navigation bar follow desired background color and theme-mode,
      // which looks nicer and more as it should on an Android device.
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        systemNavBarStyle: _navBarStyle,
        useDivider: _useNavDivider,
        opacity: widget.controller.bottomNavigationBarOpacity,
      ),
      child: Row(
        children: <Widget>[
          // The dummy demo menu and side rail.
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppConst.expandWidth),
            child: Material(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _menuWidth,
                child: SideMenu(
                  maxWidth: AppConst.expandWidth,
                  onTap: menuAvailable
                      ? () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        }
                      : null,
                ),
              ),
            ),
          ),
          // The actual page content is a normal Scaffold.
          Expanded(
            child: Scaffold(
              // For scrolling behind the app bar.
              extendBodyBehindAppBar: true,
              // For scrolling behind the bottom nav bar, if there is one.
              extendBody: true,
              appBar: AppBar(
                title: Text(AppConst.title(context)),
                actions: const <Widget>[AboutIconButton()],
              ),
              body: PageBody(
                controller: scrollController,
                constraints:
                    const BoxConstraints(maxWidth: AppConst.maxBodyWidth),
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.fromLTRB(
                    AppConst.edgePadding,
                    topPadding + kToolbarHeight + AppConst.edgePadding,
                    AppConst.edgePadding,
                    AppConst.edgePadding + bottomPadding,
                  ),
                  children: <Widget>[
                    Text('Theme', style: headline4),
                    const Text(
                      'This example shows how you can use all the built in '
                      'color schemes in FlexColorScheme to define themes '
                      'from them and how you can make your own custom '
                      'scheme colors and use them together with the '
                      'predefined ones.\n\n'
                      'The example also shows how to use the surface '
                      'branding feature and the app bar theme '
                      'options in FlexColorScheme. The usage of the '
                      'true black option for dark themes is also '
                      'demonstrated.\n\n'
                      'The example includes a dummy responsive side menu and '
                      'rail, to give a visual example of what applications '
                      'that have larger visible surfaces using surface '
                      'branding may look like. '
                      'A theme showcase widget shows the active theme with '
                      'several common Material widgets.\n',
                    ),
                    // Card with theme colors and toggle on/off
                    // using FlexColorScheme.
                    _ThemeSettings(controller: widget.controller),
                    // Card with theme mode settings.
                    _ModeSettings(controller: widget.controller),
                    // Card for enabling sub themes and their settings.
                    _SubThemes(controller: widget.controller),
                    // Surface mode settings.
                    _SurfaceSettings(controller: widget.controller),
                    // App bar theme settings.
                    _AppBarSettings(controller: widget.controller),
                    // Other settings, these settings control the annotated
                    // region and are not persisted theme settings.
                    RevealListTileCard(
                      title: Text(
                        'System navigation',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      closed: true,
                      child: Column(
                        children: <Widget>[
                          const ListTile(
                            title: Text('Android system navigation bar style'),
                            subtitle: Text(
                              'Styled with annotated region. System is white '
                              'in light theme and black in dark. '
                              'Others use their respective theme '
                              'color. Transparent shows background with system '
                              'navigation buttons on background.\n',
                            ),
                          ),
                          // AppBar style
                          CupertinoSegmentedControl<FlexSystemNavBarStyle>(
                            children: _systemNavBar,
                            groupValue: _navBarStyle,
                            onValueChanged: (FlexSystemNavBarStyle value) {
                              setState(() {
                                _navBarStyle = value;
                              });
                            },
                            borderColor: isLight
                                ? colorScheme.primary
                                : theme.primaryColorLight,
                            selectedColor: isLight
                                ? colorScheme.primary
                                : theme.primaryColorLight,
                            unselectedColor: theme.cardColor,
                          ),
                          // System navbar has divider or not?
                          SwitchListTile.adaptive(
                            title: const Text(
                              'System navbar has divider',
                            ),
                            value: _useNavDivider,
                            onChanged: (bool value) {
                              setState(() {
                                _useNavDivider = value;
                              });
                            },
                          ),
                          const ListTile(
                            title: Text('Opacity'),
                            subtitle: Text(
                              'Used by system navigation bar and themed bottom '
                              'navigation bar opacity. They are different '
                              'parameters, but share setting in this example.',
                            ),
                          ),
                          ListTile(
                            title: Slider.adaptive(
                              max: 100,
                              divisions: 100,
                              label: (widget.controller
                                          .bottomNavigationBarOpacity *
                                      100)
                                  .toStringAsFixed(0),
                              value:
                                  widget.controller.bottomNavigationBarOpacity *
                                      100,
                              onChanged: (double value) {
                                widget.controller
                                    .setBottomNavigationBarOpacity(value / 100);
                              },
                            ),
                            trailing: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    'OPACITY',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  Text(
                                    // ignore: lines_longer_than_80_chars
                                    '${(widget.controller.bottomNavigationBarOpacity * 100).toStringAsFixed(0)} %',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Sub page and splash pages demos.
                    const _SubPages(),
                    const Divider(),
                    Text('Theme Showcase', style: headline4),
                    const ThemeShowcase(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeSettings extends StatelessWidget {
  const _ThemeSettings({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final ThemeController controller;

  @override
  Widget build(BuildContext context) {
    return RevealListTileCard(
      title: Text(
        'Theme colors',
        style: Theme.of(context).textTheme.headline6,
      ),
      closed: false,
      child: Column(
        children: <Widget>[
          ThemePopupMenu(
            schemeIndex: controller.schemeIndex,
            onChanged: controller.setSchemeIndex,
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConst.edgePadding),
            child: ShowThemeColors(),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: const Text('Theme mode'),
            subtitle: Text('Using theme mode '
                '${controller.themeMode.toString().dotTail}'),
            trailing: ThemeModeSwitch(
              themeMode: controller.themeMode,
              onChanged: controller.setThemeMode,
            ),
            // Make it possible to toggle theme mode also via the ListTile.
            onTap: () {
              if (Theme.of(context).brightness == Brightness.light) {
                controller.setThemeMode(ThemeMode.dark);
              } else {
                controller.setThemeMode(ThemeMode.light);
              }
            },
          ),
          SwitchListTile.adaptive(
            title: const Text(
              'Use FlexColorScheme theming',
            ),
            subtitle: const Text(
              'Turn OFF to use default ThemeData and see the difference.',
            ),
            value: controller.useFlexColorScheme,
            onChanged: controller.setUseFlexColorScheme,
          ),
        ],
      ),
    );
  }
}

class _ModeSettings extends StatelessWidget {
  const _ModeSettings({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final ThemeController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isLight = theme.brightness == Brightness.light;

    return RevealListTileCard(
      title: Text(
        'Mode options',
        style: Theme.of(context).textTheme.headline6,
      ),
      closed: true,
      child: Column(
        children: <Widget>[
          if (isLight)
            SwitchListTile.adaptive(
              title: const Text('Light mode swap colors'),
              subtitle: const Text(
                'Turn ON to swap primary and secondary colors.',
              ),
              value: controller.swapLightColors,
              onChanged: controller.setSwapLightColors,
            )
          else
            SwitchListTile.adaptive(
              title: const Text('Dark mode swap colors'),
              subtitle: const Text(
                'Turn ON to swap primary and secondary colors.',
              ),
              value: controller.swapDarkColors,
              onChanged: controller.setSwapDarkColors,
            ),
          AnimatedSwitchHide(
            showChild: !isLight,
            duration: const Duration(milliseconds: 300),
            child: Column(
              children: <Widget>[
                // Set dark mode to use true black!
                SwitchListTile.adaptive(
                  title: const Text('True black'),
                  subtitle: const Text(
                    'Makes scaffold background black in all surface blends and '
                    'other backgrounds much darker. Keep OFF for normal '
                    'dark mode.',
                  ),
                  value: controller.darkIsTrueBlack,
                  onChanged: controller.setDarkIsTrueBlack,
                ),
                // Set to make dark scheme lazily for light theme
                SwitchListTile.adaptive(
                  title: const Text('Compute dark theme'),
                  subtitle: const Text(
                    'Calculate from the light scheme, instead '
                    'of using a predefined dark scheme.',
                  ),
                  value: controller.useToDarkMethod,
                  onChanged: controller.setUseToDarkMethod,
                ),
                // White blend slider in a ListTile.
                AnimatedSwitchHide(
                  showChild: controller.useToDarkMethod,
                  child: ListTile(
                    title: Slider.adaptive(
                      max: 100,
                      divisions: 100,
                      label: controller.darkMethodLevel.toString(),
                      value: controller.darkMethodLevel.toDouble(),
                      onChanged: (double value) {
                        controller.setDarkMethodLevel(value.floor());
                      },
                    ),
                    trailing: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'LEVEL',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            '${controller.darkMethodLevel} %',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubThemes extends StatelessWidget {
  const _SubThemes({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final ThemeController controller;

  @override
  Widget build(BuildContext context) {
    return RevealListTileCard(
      title: Text(
        'Sub themes',
        style: Theme.of(context).textTheme.headline6,
      ),
      closed: true,
      child: Column(
        children: <Widget>[
          SwitchListTile.adaptive(
            title: const Text('Use sub theming'),
            subtitle: const Text('Turn ON to enable opinionated widget '
                'sub themes.'),
            value: controller.useSubThemes,
            onChanged: controller.setUseSubThemes,
          ),
          AnimatedSwitchHide(
            showChild: controller.useSubThemes,
            child: Column(
              children: <Widget>[
                // AppBar elevation value in a ListTile.
                ListTile(
                  title: const Text('Corner border radius'),
                  subtitle: Slider.adaptive(
                    max: 30,
                    divisions: 30,
                    label: controller.cornerRadius.toStringAsFixed(0),
                    value: controller.cornerRadius,
                    onChanged: controller.setCornerRadius,
                  ),
                  trailing: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'dP',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          controller.cornerRadius.toStringAsFixed(0),
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SwitchListTile.adaptive(
                  title: const Text('Themed state effects'),
                  subtitle: const Text('Hover, focus, highlight and '
                      'splash use primary color.'),
                  value: controller.themedEffects,
                  onChanged: controller.setThemedEffects,
                ),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  title: const Text(
                    'Input decorator has fill color',
                  ),
                  value: controller.inputDecoratorIsFilled,
                  onChanged: controller.setInputDecoratorIsFilled,
                ),
                SwitchListTile.adaptive(
                  title: const Text(
                    'Input decorator border style',
                  ),
                  subtitle: const Text(
                    'ON for outline, OFF for underline.',
                  ),
                  value: controller.inputDecoratorIsOutlinedBorder,
                  onChanged: controller.setInputDecoratorIsOutlinedBorder,
                ),
                SwitchListTile.adaptive(
                  title: const Text(
                    'Unfocused input decorator has border',
                  ),
                  // subtitle: const Text(
                  //   'ON for outline, OFF for underline.',
                  // ),
                  value: controller.inputDecoratorUnfocusedHasBorder,
                  onChanged: controller.setInputDecoratorUnfocusedHasBorder,
                ),
                const Divider(height: 1),
              ],
            ),
          ),
          // Tooltip theme style.
          Tooltip(
            message: 'A tooltip, on the tooltip style toggle',
            child: SwitchListTile.adaptive(
              title: const Text(
                'Tooltips are light on light, and dark on dark',
              ),
              subtitle: const Text(
                "Keep OFF to use Material's default inverted "
                'background style.',
              ),
              value: controller.tooltipsMatchBackground,
              onChanged: controller.setTooltipsMatchBackground,
            ),
          ),
        ],
      ),
    );
  }
}

class _SurfaceSettings extends StatelessWidget {
  const _SurfaceSettings({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final ThemeController controller;

  String explainMode(final FlexSurfaceMode mode) {
    switch (mode) {
      case FlexSurfaceMode.flat:
        return 'Flat: All surface and background colors at blend level (1x)';
      case FlexSurfaceMode.highBackground:
        return 'High background: Background (2x) Surface (1x) Scaffold (1/4x)';
      case FlexSurfaceMode.highSurface:
        return 'High surface: Surface (2x) Background (1x) Scaffold (1/4x)';
      case FlexSurfaceMode.lowScaffold:
        return 'Low scaffold: Scaffold (1/3x) Surface and Background (1x)';
      case FlexSurfaceMode.highScaffold:
        return 'High scaffold: Scaffold (3x) Surface and Background (1x)\n'
            'When used, scaffold content typically placed in cards with '
            'less primary color blend.';
      case FlexSurfaceMode.lowScaffoldVariantDialog:
        return 'Low scaffold: Scaffold (1/3x) Surface and Background (1x)\n'
            'Dialog background (1x) using secondary variant color';
      case FlexSurfaceMode.highScaffoldVariantDialog:
        return 'High scaffold: Scaffold (3x) Surface and Background (1x)\n'
            'Dialog background (1x) using secondary variant color';
      case FlexSurfaceMode.custom:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return RevealListTileCard(
      title: Text(
        'Surface blends',
        style: Theme.of(context).textTheme.headline6,
      ),
      closed: true,
      child: Column(
        children: <Widget>[
          const ListTile(
            title: Text('Alpha blended surfaces and backgrounds'),
            isThreeLine: true,
            subtitle: Text(
              'Default Material design uses white and dark background colors. '
              'With FlexColorScheme you can adjust the primary color '
              'alpha blend strategy used on surface and background colors.',
            ),
          ),
          ListTile(
            title: const Text('Surface mode'),
            subtitle: Text(explainMode(controller.surfaceMode)),
          ),
          ListTile(
            trailing: SurfaceModeButtons(
              mode: controller.surfaceMode,
              onChanged: controller.setSurface,
            ),
          ),
          const ListTile(
            title: Text('Alpha blend level'),
            subtitle: Text(
              'Adjust level of surface color alpha blending',
            ),
          ),
          ListTile(
            title: Slider.adaptive(
              min: 0,
              max: 20,
              divisions: 20,
              label: controller.blendLevel.index.toString(),
              value: controller.blendLevel.index.toDouble(),
              onChanged: (double value) {
                final int level = value.toInt();
                controller.setBlendLevel(FlexBlendLevel.values[level]);
              },
            ),
            trailing: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'LEVEL',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    '${controller.blendLevel.index}',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarSettings extends StatelessWidget {
  const _AppBarSettings({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final ThemeController controller;

  // FlexAppBarStyle enum to widget map, used in a CupertinoSegment control.
  static const Map<FlexAppBarStyle, Widget> _themeAppBar =
      <FlexAppBarStyle, Widget>{
    FlexAppBarStyle.primary: Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        'Primary\ncolor',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    ),
    FlexAppBarStyle.material: Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        // Wait, what is \u{00AD} below?? It is Unicode char-code for an
        // invisible soft hyphen. It can be used to guide text layout where
        // it can break a word to the next line, if it has to. On small phones
        // or a desktop builds where you can make the UI really narrow in
        // Flutter, you can observe this with the 'background' word below.
        'Material guide\nback\u{00AD}ground',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    ),
    FlexAppBarStyle.surface: Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        'Branded\nsurface',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    ),
    FlexAppBarStyle.background: Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        'Branded\nback\u{00AD}ground',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    ),
    FlexAppBarStyle.custom: Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        'Custom\ncolor',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    ),
  };

  // FlexTabBarStyle enum to widget map, used in a CupertinoSegment control.
  static const Map<FlexTabBarStyle, Widget> _themeTabBar =
      <FlexTabBarStyle, Widget>{
    FlexTabBarStyle.forAppBar: Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        'TabBar used\nin AppBar',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    ),
    FlexTabBarStyle.forBackground: Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        'TabBar used\non background',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    ),
    FlexTabBarStyle.useDefault: Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        'TabBar uses\nSDK default',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    ),
    FlexTabBarStyle.universal: Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        'TabBar uses\nuniversal style',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    ),
  };

  String explainStyle(final FlexAppBarStyle style, final bool isLight) {
    switch (style) {
      case FlexAppBarStyle.primary:
        return 'Use primary color.';
      case FlexAppBarStyle.material:
        return isLight
            ? 'Use Material guide light theme background color (white).'
            : 'Use Material guide dark theme background color (#121212).';
      case FlexAppBarStyle.surface:
        return 'Use the primary branded surface color.';
      case FlexAppBarStyle.background:
        return 'Use the primary branded background color.';
      case FlexAppBarStyle.custom:
        return 'Uses secondary variant color, but you can make it any color.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isLight = theme.brightness == Brightness.light;
    final ColorScheme colorScheme = theme.colorScheme;

    return RevealListTileCard(
      title: Text(
        'AppBar style',
        style: Theme.of(context).textTheme.headline6,
      ),
      closed: true,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          const ListTile(
            subtitle: Text(
              'Flutter SDK ColorScheme based themes have a primary '
              'colored AppBar in light mode, and a Material guide background '
              'colored one in dark mode. With FlexColorScheme you can choose '
              'if it should be primary color, Material guide background color, '
              'branded background, branded surface or a custom color. '
              'The predefined schemes use their secondary variant color as '
              'the custom color for the AppBar color, but it can be any color.',
            ),
          ),
          if (isLight) ...<Widget>[
            ListTile(
              title: const Text('Light AppBar theme'),
              subtitle: Text(
                explainStyle(controller.lightAppBarStyle, isLight),
              ),
            ),
            CupertinoSegmentedControl<FlexAppBarStyle>(
              children: _themeAppBar,
              groupValue: controller.lightAppBarStyle,
              onValueChanged: controller.setLightAppBarStyle,
              borderColor:
                  isLight ? colorScheme.primary : theme.primaryColorLight,
              selectedColor:
                  isLight ? colorScheme.primary : theme.primaryColorLight,
              unselectedColor: theme.cardColor,
            )
          ] else ...<Widget>[
            ListTile(
              title: const Text('Dark AppBar theme'),
              subtitle: Text(
                explainStyle(controller.darkAppBarStyle, isLight),
              ),
            ),
            CupertinoSegmentedControl<FlexAppBarStyle>(
              children: _themeAppBar,
              groupValue: controller.darkAppBarStyle,
              onValueChanged: controller.setDarkAppBarStyle,
              borderColor:
                  isLight ? colorScheme.primary : theme.primaryColorLight,
              selectedColor:
                  isLight ? colorScheme.primary : theme.primaryColorLight,
              unselectedColor: theme.cardColor,
            ),
          ],
          SwitchListTile.adaptive(
            title: const Text(
              'One toned AppBar with transparent status bar',
            ),
            subtitle: const Text(
              'If ON there is no scrim on the status bar. '
              'Turn OFF for normal two toned AppBar on Android.',
            ),
            value: controller.transparentStatusBar,
            onChanged: controller.setTransparentStatusBar,
          ),
          ListTile(
              title: const Text('Elevation'),
              subtitle: Slider.adaptive(
                max: 24,
                divisions: 48,
                label: controller.appBarElevation.toStringAsFixed(1),
                value: controller.appBarElevation,
                onChanged: controller.setAppBarElevation,
              ),
              trailing: Padding(
                padding: const EdgeInsetsDirectional.only(end: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'ELEVATE',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      controller.appBarElevation.toStringAsFixed(1),
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
          const ListTile(
            title: Text('Background opacity'),
            subtitle: Text(
              'Set themed AppBar opacity, typically 85% to 98% works well.',
            ),
          ),
          ListTile(
            title: Slider.adaptive(
              max: 100,
              divisions: 100,
              label: (controller.appBarOpacity * 100).toStringAsFixed(0),
              value: controller.appBarOpacity * 100,
              onChanged: (double value) {
                controller.setAppBarOpacity(value / 100);
              },
            ),
            trailing: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'OPACITY',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    '${(controller.appBarOpacity * 100).toStringAsFixed(0)}'
                    ' %',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          const ListTile(
            title: Text('TabBar theme'),
            subtitle: Text(
              'Choose the style that fit best with where '
              'you primarily intend to use the TabBar.',
            ),
          ),
          const SizedBox(height: 4),
          CupertinoSegmentedControl<FlexTabBarStyle>(
            children: _themeTabBar,
            groupValue: controller.tabBarStyle,
            onValueChanged: controller.setTabBarStyle,
            borderColor:
                isLight ? colorScheme.primary : theme.primaryColorLight,
            selectedColor:
                isLight ? colorScheme.primary : theme.primaryColorLight,
            unselectedColor: theme.cardColor,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SubPages extends StatelessWidget {
  const _SubPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RevealListTileCard(
      title: Text(
        'Page examples',
        style: Theme.of(context).textTheme.headline6,
      ),
      closed: true,
      child: Column(
        children: <Widget>[
          ListTile(
            title: const Text('Open a demo subpage'),
            subtitle: const Text(
              'The subpage will use the same '
              'color scheme based theme automatically.',
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Subpage.show(context);
            },
          ),
          ListTile(
            title: const Text('Splash page demo 1a'),
            subtitle: const Text(
              'No scrim and normal status icons.\n'
              'Using themedSystemNavigationBar (noAppBar:true)',
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              SplashPageOne.show(context, false);
            },
          ),
          ListTile(
            title: const Text('Splash page demo 1b'),
            subtitle: const Text(
              'No scrim and inverted status icons.\n'
              'Using themedSystemNavigationBar (noAppBar:true, '
              'invertStatusIcons:true)',
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              SplashPageOne.show(context, true);
            },
          ),
          ListTile(
            title: const Text('Splash page demo 2'),
            subtitle: const Text(
              'No status icons or navigation bar.\n'
              'Using setEnabledSystemUIOverlays([])',
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              SplashPageTwo.show(context, true);
            },
          ),
        ],
      ),
    );
  }
}
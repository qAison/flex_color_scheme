import 'package:flutter/material.dart';

import '../all_shared_imports.dart';
// It is not necessary to review or understand the code in this file in order
// to understand how to use the FlexColorScheme package demonstrated in
// the examples.

// This sub page is used as a demo in Examples 4 and 5 to show a sub-page
// using the same FlexColorScheme based theme.
class Subpage extends StatefulWidget {
  const Subpage({Key? key}) : super(key: key);

  // A static convenience function show this screen, as pushed on top.
  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push<Widget>(
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) => const Subpage(),
      ),
    );
  }

  @override
  _SubpageState createState() => _SubpageState();
}

class _SubpageState extends State<Subpage> {
  int _buttonIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final TextStyle headline4 = textTheme.headline4!;

    final MediaQueryData media = MediaQuery.of(context);
    final double topPadding = media.padding.top + kToolbarHeight * 2;
    final double bottomPadding =
        media.padding.bottom + kBottomNavigationBarHeight;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // For scrolling behind the app bar.
        extendBodyBehindAppBar: true,
        // For scrolling behind the bottom nav bar, if there is one.
        extendBody: true,
        appBar: AppBar(
          title: const Text('Subpage Demo'),
          actions: const <Widget>[AboutIconButton()],
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Home'),
              Tab(text: 'Favorites'),
              Tab(text: 'Profile'),
              Tab(text: 'Settings'),
            ],
          ),
        ),
        body: PageBody(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              AppConst.edgePadding,
              topPadding + AppConst.edgePadding,
              AppConst.edgePadding,
              AppConst.edgePadding + bottomPadding,
            ),
            children: <Widget>[
              Text('Subpage demo', style: headline4),
              const Text(
                'This page just shows another example page with the same '
                'FlexColorScheme based theme applied when you open a subpage. '
                'It also has a BottomNavigationBar and TabBar in the AppBar.',
              ),
              const Divider(),
              // Show all key active theme colors.
              Text('Theme colors', style: headline4),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConst.edgePadding),
                child: ShowThemeColors(),
              ),
              const Divider(),
              Text('Theme Showcase', style: headline4),
              const ThemeShowcase(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int value) {
            setState(() {
              _buttonIndex = value;
            });
          },
          currentIndex: _buttonIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              label: 'Chat',
              // API still only on Master channel
              // tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.beenhere),
              label: 'Tasks',
              // API still only on Master channel
              // tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create_new_folder),
              label: 'Archive',
              // API still only on Master channel
              // tooltip: '',
            ),
          ],
        ),
      ),
    );
  }
}
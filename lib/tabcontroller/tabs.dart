import 'package:flutter/material.dart';
import 'package:com.ozlisten.ozlistenapp/album/gridview_main.dart';
import 'package:com.ozlisten.ozlistenapp/audio_data/favorite_audio.dart';
import 'package:com.ozlisten.ozlistenapp/audio_data/load_audio.dart';
import 'package:com.ozlisten.ozlistenapp/audio_data/main_player.dart';
import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:com.ozlisten.ozlistenapp/profile/profile_screen.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';

class TabContainerBottom extends StatefulWidget {
  
  int selectedIndex;
  TabContainerBottom({this.selectedIndex});
  
  static Route route(int selectedIndex) {
    return MaterialPageRoute<void>(
      builder: (_) => TabContainerBottom(selectedIndex: selectedIndex),
    );
  }

  @override
  State createState() => _TabContainerBottomState();
}

class _TabContainerBottomState extends State<TabContainerBottom> {
  ///
  final int _homeIndex = 0;
  int _selectedIndex;
  ///

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
    bool lp = true;
    String methodName = 'initState tabs.dart';
    p('-->38 initState', '===========', methodName, lp);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ///
  final List<Widget> _widgetOptions = <Widget>[
    GridViewMain(paidOnly: false), // all
    Load_audio(), // 1
    Favorite_audio(),  // 2
    PlayerMain(), // 3
    GridViewMain(paidOnly: true), // only paid
    ProfilePage(), // 5
  ];

  Widget bottomBar() {
    bool lp = false;
    String methodName = 'bottomBar tabs.dart';
    p('-->58 bottomBar', '+++++++++++', methodName, lp);
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        backgroundColor: primaryColor,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          _onItemTapped(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.art_track),
            label: 'Audio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            // activeIcon: Icon(Icons.audiotrack, color: Colors.red,),
            icon: Icon(Icons.audiotrack),
            label: 'Player',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: 'Purchased',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: 'Profile',
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    bool lp = false;
    String methodName = 'build tabs.dart';
    p('-->95 build', '----------------', methodName, lp);
    return WillPopScope(
      onWillPop: () {
        // check if current tab
        // back to home tab if current tab not home
        // close app if current tab is home tab
        bool willPop = _selectedIndex == _homeIndex;
        setState(() {
          _selectedIndex = _homeIndex;
        });
        return Future<bool>.value(willPop);
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
        bottomNavigationBar: bottomBar(),
      ),
    );
  }
}

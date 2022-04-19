//import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/pages/Tabs/MyGym.dart';
import 'package:uphold/pages/Tabs/MyOrder.dart';
import 'Login.dart';
import 'Tabs/Home.dart';
import 'Tabs/Person.dart';
import '../components/bottom_bar.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {

  int _currentIndex = 0;
  PageController _pageController = PageController();

  _checkLogin() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final bool? login = prefs.getBool('isLogin');
    print("tabsreadlogin: "+login.toString());
    if(!login!){
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>Login())
      );
    }
  }

  _readToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");
    print("readtoken:"+token!);
  }

  @override
  void initState() {
    super.initState();
    _checkLogin();
    //_readToken();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            HomePage(),
            MyGym(),
            MyOrder(),
            PersonPage(),
          ],
        ),
      ),
      bottomNavigationBar:
      BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        containerHeight: 65,
        itemCornerRadius: 45,
        iconSize: 27,
        curve: Curves.easeOutQuint,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          // _pageController.jumpToPage(index);
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 800), curve: Curves.ease);

        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('首页',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
            textAlign: TextAlign.center,
            inactiveColor: Colors.black54,
            activeColor: Colors.blueAccent,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.accessible_forward),
              textAlign: TextAlign.center,
              title: Text('健身',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
              inactiveColor: Colors.black54,
              activeColor: Colors.blueAccent,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.account_balance_wallet),
              textAlign: TextAlign.center,
              title: Text('预约',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
              inactiveColor: Colors.black54,
              activeColor: Colors.blueAccent),
          BottomNavyBarItem(
              icon: Icon(Icons.person),
              textAlign: TextAlign.center,
              title: Text('个人',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
              inactiveColor: Colors.black54,
              activeColor: Colors.blueAccent),
        ],
      ),
    );
  }
}

// class Tabs extends StatefulWidget {
//   const Tabs({Key? key}) : super(key: key);
//
//   @override
//   _TabsState createState() => _TabsState();
// }
//
// class _TabsState extends State<Tabs> {
//   int _currentIndex = 0;
//   List _pageList = [
//     HomePage(),
//     MyGym(),
//     MyOrder(),
//     PersonPage(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: new Text('UpHold'),
//           elevation: 0,
//         ),
//         body: this._pageList[this._currentIndex],
//         bottomNavigationBar: BottomNavyBar(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           selectedIndex: _currentIndex,
//           containerHeight: 65,
//           iconSize: 25,
//           curve: Curves.decelerate,
//           showElevation: false, // use this to remove appBar's elevation
//           onItemSelected: (index) => setState(() {
//             _currentIndex = index;
//           }),
//           items: [
//             BottomNavyBarItem(
//               icon: Icon(Icons.home),
//               title: Text('首页'),
//               inactiveColor: Colors.black54,
//               activeColor: Colors.blue,
//             ),
//             BottomNavyBarItem(
//                 icon: Icon(Icons.accessible_forward),
//                 title: Text('健身房'),
//                 inactiveColor: Colors.black54,
//                 activeColor: Colors.blue),
//             BottomNavyBarItem(
//                 icon: Icon(Icons.account_balance_wallet),
//                 title: Text('我的预约'),
//                 inactiveColor: Colors.black54,
//                 activeColor: Colors.blue),
//             BottomNavyBarItem(
//                 icon: Icon(Icons.person),
//                 title: Text('个人中心'),
//                 inactiveColor: Colors.black54,
//                 activeColor: Colors.blue),
//           ],
//         )
//         );
//   }
// }

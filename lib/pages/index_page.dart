import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_page.dart';
import 'category_page.dart';
import 'cart_page.dart';
import 'member_page.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  int _currentIndex = 0;
//  var _currentPage;
  final List<Widget> tabPages = [
    HomePage(),
    CategoryPage(),
    MemberPage(),
    CartPage()
  ];
  final List<BottomNavigationBarItem> _bottomTabs = [
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), title: Text('首页')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.search), title: Text('分类')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.shopping_cart), title: Text('购物车')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.profile_circled), title: Text('会员中心')),
  ];

  @override
  void initState() {
    // TODO: implement initState
//    _currentPage = tabPages[_currentIndex];
    print('initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)
      ..init(context);
    ;
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomTabs,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
//            _currentPage = tabPages[index];
            print('setState');
          });
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: tabPages,
      ),
    );
  }
}

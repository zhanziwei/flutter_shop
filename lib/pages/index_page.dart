import 'package:flutter/material.dart';
import 'member_page.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'category_page.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _currentIndex = 0;
  var _currentPage;

  final List<BottomNavigationBarItem> _bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('首页')
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text('分类')
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart),
        title: Text('购物车')
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        title: Text('会员中心')
    ),
  ];

  final List _pageTabs = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage(),
  ];

  @override
  void initState() {
    _currentPage = _pageTabs[_currentIndex];
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomTabs,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _currentPage = _pageTabs[index];
          });
        },
      ),
      body: _currentPage,
    );
  }
}


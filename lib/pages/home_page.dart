import 'dart:convert';

import 'package:flutter/material.dart';
import '../services/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String homePageContent = '正在获取数据';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+')),
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            List<Map> swiperDataList = (data['data']['slides'] as List).cast();
            return Column(
              children: <Widget>[
                HomePageSwiper(swiperDataList: swiperDataList),
              ],
            );
          } else {
            return Center(
              child: Text("加载中"),
            );
          }
        },
      ), // 这个会和listView冲突
    );
  }
}

class HomePageSwiper extends StatelessWidget {
  final List swiperDataList;

  const HomePageSwiper({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 333,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return new Image.network(
            swiperDataList[index]['image'],
            fit: BoxFit.fill,
          );
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/details_pages/details_web.dart';
import 'package:flutter_shop/provide/details_info_provide.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/pages/details_pages/details_top_area.dart';
import 'package:flutter_shop/pages/details_pages/details_explain.dart';
import 'package:flutter_shop/pages/details_pages/details_tabBar.dart';

class DetailsPage extends StatelessWidget {

  final String goodsId;
  DetailsPage(this.goodsId);
  @override
  Widget build(BuildContext context) {
    _getBackInfo(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pop(context);
        }),
        title: Text('商品详细页'),
      ),

      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (context, snapshot) {
        if(snapshot.hasData) {
          return Stack(
            children: <Widget>[
              Container(
                child: ListView(      // 应该用listView更好一点
                  children: <Widget>[
                    DetailsTopArea(),
                    DetailExplain(),
                    DetailsTabBar(),
                    DetailsWeb()
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Text('测试'),
              )
            ],
          );
        } else {
          return Text('加载中');
        }
      }),
    );
  }

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '完成加载';
  }
}



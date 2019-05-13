import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../service/service_method.dart';
import 'package:flutter_shop/routers/application.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  int page = 1;
  List<Map> hotGoodsList = [];
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  String homePageContent = '正在获取数据';
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('百姓生活+'),
        ),
        body: FutureBuilder(
            future: getHomePageContent,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = json.decode(snapshot.data.toString())['data'];
                List<Map> swiperList = (data['slides'] as List).cast();
                List<Map> navigatorList = (data['category'] as List).cast();
                List<Map> recommendList = (data['recommend'] as List).cast();
                String floor1Title =data['floor1Pic']['PICTURE_ADDRESS'];
                String floor2Title =data['floor2Pic']['PICTURE_ADDRESS'];
                String floor3Title =data['floor3Pic']['PICTURE_ADDRESS'];
                List<Map> floor1 = (data['floor1'] as List).cast();
                List<Map> floor2 = (data['floor2'] as List).cast();
                List<Map> floor3 = (data['floor3'] as List).cast();
                String advertisePicture = data['advertesPicture']['PICTURE_ADDRESS'];
                String leaderImage = data['shopInfo']['leaderImage'];
                String leaderPhone = data['shopInfo']['leaderPhone'];

                return EasyRefresh(
                  refreshFooter: ClassicsFooter(
                    bgColor: Colors.white,
                    textColor: Colors.blue,
                    moreInfoColor: Colors.pink,
                    showMore: true,
                    noMoreText: "",
                    moreInfo: '加载中',
                    loadReadyText: '上拉加载',
                    key:_footerKey,
                  ),
                  child: ListView(    // ListView需要设置宽高
                    children: <Widget>[
                      SwiperDiy(swiperList: swiperList,),
                      TopNavigator(navigatorList: navigatorList,),
                      AdBanner(advertisePicture: advertisePicture,),
                      LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone),
                      Recommend(recommendList: recommendList),
                      FloorTitle(picture_address:floor1Title),
                      FloorContent(floorGoodsList:floor1),
                      FloorTitle(picture_address:floor2Title),
                      FloorContent(floorGoodsList:floor2),
                      FloorTitle(picture_address:floor3Title),
                      FloorContent(floorGoodsList:floor3),
                      _hotGoods(),
                    ],
                  ),

                  loadMore: ()async{
                    var formPage = {'page':page};
                    request('homePageBelowContent', formData: formPage).then((val) {
                      var data = json.decode(val.toString());
                      List<Map> newGoodsList = (data['data'] as List).cast();
                      setState(() {
                        hotGoodsList.addAll(newGoodsList);
                        page++;
                      });
                    });
                  },
                );
              } else {
                return Center(
                  child: Text('加载中'),
                );
              }
            },
          ),
        );
  }

  @override
  bool get wantKeepAlive => true;

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    alignment: Alignment.center,
    color: Colors.transparent,
    child: Text('火爆专区'),
    padding: EdgeInsets.all(5),
  );

  Widget _wrapList() {
    if(hotGoodsList.length != 0) {    // 不判断会报错
      List<Widget> listWidget = hotGoodsList.map((val) {
        return InkWell(
          onTap: (){
            Application.router.navigateTo(context, '/details?id=${val['goodsId']}');
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 3),
            child: Column(
              children: <Widget>[
                Image.network(val['image'], width: ScreenUtil().setWidth(370),),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color:Colors.pink, fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text(' ');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList(),
        ],
      ),
    );
  }
}

class SwiperDiy extends StatelessWidget {
  final List swiperList;

  SwiperDiy({Key key, this.swiperList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Application.router.navigateTo(context, '/details?id=${swiperList[index]['goodsId']}');
            },
            child: Image.network("${swiperList[index]['image']}",
                fit: BoxFit.fill),
          );
        },
        itemCount: swiperList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItem(BuildContext context, item) {
    return InkWell(
      onTap: () {

      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),

          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (navigatorList.length > 10) {
      navigatorList.removeRange(10, navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(4),
        children: navigatorList.map((item) {
          return _gridViewItem(context, item);
        }).toList(),
      ),
    );
  }
}

class AdBanner extends StatelessWidget {
  final String advertisePicture;

  AdBanner({Key key, this.advertisePicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(advertisePicture),
    );
  }
}

class LeaderPhone extends StatelessWidget {
  final String leaderImage; //店长图片
  final String leaderPhone; //店长电话

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Recommend extends StatelessWidget {
  final List recommendList;

  Widget _titleWidget() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
        child: Text('商品推荐', style: TextStyle(color: Colors.pink)));
  }

  Widget _recommendList() {
    return SingleChildScrollView(
      child: Container(
        height: ScreenUtil().setHeight(350),
        child: ListView.builder(
          // ListView.builder可以复用里面的代码
          scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          itemBuilder: (context, index) {
            return _item(context, index);
          },
        ),
      ),
    );
  }

  Widget _item(BuildContext context, int index) {
    return InkWell(
        onTap: () {
          Application.router.navigateTo(context, '/details?id=${recommendList[index]['goodsId']}');
        },
          child: Container(
            width: ScreenUtil().setWidth(250),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    left: BorderSide(width: 0.5, color: Colors.black12))),
            child: Column(
              children: <Widget>[
                Image.network(recommendList[index]['image']),
                Text('￥${recommendList[index]['mallPrice']}'),
                Text(
                  '￥${recommendList[index]['price']}',
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey),
                )
              ],
            ),
          ),
        );
  }

  Recommend({Key key, this.recommendList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[_titleWidget(), _recommendList()],
        ),
      ),
    );
  }
}

class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_firstRow(context), _otherGoods(context)],
      ),
    );
  }

  Widget _firstRow(BuildContext context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(context, floorGoodsList[1]),
            _goodsItem(context, floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods(BuildContext context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[3]),
        _goodsItem(context, floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(BuildContext context, Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          Application.router.navigateTo(context, '/details?id=${goods['goodsId']}');
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}

class FloorTitle extends StatelessWidget {
  final String picture_address; // 图片地址
  FloorTitle({Key key, this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}
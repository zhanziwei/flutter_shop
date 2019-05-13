import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/provide/child_category_provide.dart';
import 'package:flutter_shop/provide/goods_list_provide.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'package:provide/provide.dart';
import '../model/category_big_model.dart';
import '../model/category_goods_list_model.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            BigCategoryNav(),
            Expanded(
                child: Column(
              children: <Widget>[
                SubCategoryNav(),
                GoodsList(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class BigCategoryNav extends StatefulWidget {
  @override
  _BigCategoryNavState createState() => _BigCategoryNavState();
}

class _BigCategoryNavState extends State<BigCategoryNav> {
  List bigList = [];
  var listIndex = 0;

  @override
  void initState() {
    super.initState();
    _getCategory();
    _getGoodsList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
          itemCount: bigList.length,
          itemBuilder: (context, index) {
            return _leftInkWell(index);
          }),
    );
  }

  void _getCategory() async {
    await request('categoryContent').then((val) {
      var data = json.decode(val.toString());
      CategoryBigModel categoryBigModel = CategoryBigModel.fromJson(data);
      setState(() {
        bigList = categoryBigModel.categoryBigList;
      });

      Provide.value<ChildCategoryProvide>(context)
          .getChildCategory(bigList[0].bxMallSubDto, bigList[0].mallCategoryId);
    });
  }

  void _getGoodsList({String categoryId}) async {
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': '',
      'page': 1
    };

    await request('mallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel categoryGoodsListModel =
          CategoryGoodsListModel.fromJson(data);
      Provide.value<GoodsListProvide>(context)
          .getGoodsList(categoryGoodsListModel.data);
    });
  }

  Widget _leftInkWell(int index) {
    bool isActive = false;
    isActive = (index == listIndex) ? true : false;
    return InkWell(
      onTap: () {
        var childList = bigList[index].bxMallSubDto;
        var categoryId = bigList[index].mallCategoryId;
        Provide.value<ChildCategoryProvide>(context)
            .getChildCategory(childList, categoryId);
        setState(() {
          listIndex = index;
        });

        _getGoodsList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
            color: isActive ? Colors.black26 : Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text(
          bigList[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }
}

class SubCategoryNav extends StatefulWidget {
  @override
  _SubCategoryNavState createState() => _SubCategoryNavState();
}

class _SubCategoryNavState extends State<SubCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategoryProvide>(
      builder: (context, child, childCategory) {
        return Container(
          height: ScreenUtil().setHeight(80),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
          ),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: childCategory.childCategoryList.length,
              itemBuilder: (context, index) {
                return _rightInkWell(
                    index, childCategory.childCategoryList[index]);
              }),
        );
      },
    );
  }

  void _getGoodsList(String categorySubId) async {
    var data = {
      'categoryId': Provide.value<ChildCategoryProvide>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    await request('mallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel categoryGoodsListModel =
          CategoryGoodsListModel.fromJson(data);
      if (categoryGoodsListModel.data == null) {
        Provide.value<GoodsListProvide>(context).getGoodsList([]);
      } else {
        Provide.value<GoodsListProvide>(context)
            .getGoodsList(categoryGoodsListModel.data);
      }
    });
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isActive = false;
    isActive =
        (index == Provide.value<ChildCategoryProvide>(context).childIndex)
            ? true
            : false;
    return InkWell(
      onTap: () {
        Provide.value<ChildCategoryProvide>(context)
            .changeChildIndex(index, item.mallSubId);
        _getGoodsList(item.mallSubId);
      },
      child: Container(
        color: isActive ? Colors.black26 : Colors.white,
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Text(
          item.mallSubName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }
}

class GoodsList extends StatefulWidget {
  @override
  _GoodsListState createState() => _GoodsListState();
}

class _GoodsListState extends State<GoodsList> {
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Provide<GoodsListProvide>(
      builder: (context, child, data) {
        try {
          if (Provide.value<ChildCategoryProvide>(context).page == 1) {
            scrollController.jumpTo(0.0);
          }
        } catch (e) {
          print('进入页面第一次初始化$e');
        }
        if (data.goodsList.length > 0) {
          return Expanded(
              child: EasyRefresh(
            refreshFooter: ClassicsFooter(
              key: _footerKey,
              bgColor: Colors.white,
              textColor: Colors.blue,
              moreInfoColor: Colors.pink,
              showMore: true,
              noMoreText:
                  Provide.value<ChildCategoryProvide>(context).noMoreText,
              moreInfo: '加载中',
              loadReadyText: '上拉加载',
            ),
            child: ListView.builder(
              controller: scrollController,
              itemCount: data.goodsList.length,
              itemBuilder: (context, index) {
                return _goodsInkWell(data.goodsList, index);
              }
            ),
            loadMore: () async {
              _getMoreList();
            },
          ));
        } else {
          return Text('暂时没有数据');
        }
      },
    );
  }

  void _getMoreList() async {
    Provide.value<ChildCategoryProvide>(context).addPage();
    var data = {
      'categoryId': Provide.value<ChildCategoryProvide>(context).categoryId,
      'categorySubId': Provide.value<ChildCategoryProvide>(context).subId,
      'page': Provide.value<ChildCategoryProvide>(context).page
    };

    await request('mallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel categoryGoodsListModel =
          CategoryGoodsListModel.fromJson(data);
      if (categoryGoodsListModel.data == null) {
        Fluttertoast.showToast(
            msg: '已经到底了',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
        );
        Provide.value<ChildCategoryProvide>(context).changeNoMoreText('没有更多');
      } else {
        Provide.value<GoodsListProvide>(context)
            .getMoreList(categoryGoodsListModel.data);
      }
    });
  }

  Widget _goodsImage(List newList, int index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(List newList, int index) {
    return Container(
      padding: EdgeInsets.all(5),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(List newList, int index) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格：￥${newList[index].presentPrice}',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '价格：￥${newList[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          )
        ],
      ),
    );
  }

  Widget _goodsInkWell(List newList, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.black12))),
        child: Row(
          children: <Widget>[
            _goodsImage(newList, index),
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index),
              ],
            )
          ],
        ),
      ),
    );
  }
}

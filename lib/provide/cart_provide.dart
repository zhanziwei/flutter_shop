import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_shop/model/cartInfo_model.dart';

class CartProvide with ChangeNotifier {

  String cartString = "[]";
  List<CartInfoModel> cartInfoList = [];
  save(goodsId, goodsName, count, price, images) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    cartString = preferences.getString('cartInfo');
    var temp = cartString==null?[]:json.decode(cartString);
    List<Map> tempList = (temp as List).cast();
    bool isHave = false;
    int ival = 0;
    tempList.forEach((val) {
      print(val['goodsId']);
      if(val['goodsId'] == goodsId) {
        tempList[ival]['count'] = val['count']+1;
        cartInfoList[ival].count++;
        isHave = true;
      }

      ival++;
    });

    if(!isHave) {
      Map<String, dynamic>newGoods = {
        'goodsId':goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images,
      };
      tempList.add(newGoods);
      cartInfoList.add(CartInfoModel.fromJson(newGoods));     // 变成对象，而不是map
    }

    cartString = json.encode(tempList).toString();

    preferences.setString('cartInfo', cartString);
    notifyListeners();
  }

  remove() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('cartInfo');
    cartInfoList = [];
    notifyListeners();
  }

  getCartInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    cartString = preferences.getString('cartInfo');
    cartInfoList = [];
    if(cartString != null) {
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      tempList.forEach((val) {
        cartInfoList.add(CartInfoModel.fromJson(val));
      });
    }

    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import '../model/category_goods_list_model.dart';

class GoodsListProvide with ChangeNotifier {
  List<Goods> goodsList = [];

  getGoodsList(List<Goods> list) {
    goodsList = list;
    notifyListeners();
  }

  getMoreList(List<Goods> list) {
    goodsList.addAll(list);
    notifyListeners();
  }
}
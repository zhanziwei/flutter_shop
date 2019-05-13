// 控制类别页面中的子标题内容传递。
import 'package:flutter/material.dart';
import '../model/category_big_model.dart';

class ChildCategoryProvide with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0;
  String categoryId = '4';
  String subId = "";

  int page = 1; // 列表页数
  String  noMoreText = '';  // 显示没有数据的文字
  getChildCategory(List<BxMallSubDto> list, String id) {
    categoryId = id;
    childIndex = 0;
    subId = '';
    page = 1;
    noMoreText = '';
    BxMallSubDto all = BxMallSubDto();
    all.mallSubName = '全部';
    all.mallSubId = '';
    all.comments = 'null';
    all.mallCategoryId = '00';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  changeChildIndex(int index, String id) {
    childIndex = index;
    subId = id;
    notifyListeners();
  }

  addPage() {
    page++;
    notifyListeners();
  }

  changeNoMoreText(String text) {
    noMoreText = text;
    notifyListeners();
  }

}
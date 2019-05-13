import 'package:flutter/material.dart';
import '../model/details_model.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  DetailsModel goodsInfo;
  bool isLeft = true;
  bool isRight = false;

  changeLeftOrRight(String changeState) {
    if(changeState == 'left') {
      isLeft = true;
      isRight = false;
    } else {
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }
  getGoodsInfo(String id) async {
    var formData = {
      'goodId':id,
    };

    await request('detailsGoods', formData: formData).then((val) {
      var responseData = json.decode(val.toString());
      goodsInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });


  }
}
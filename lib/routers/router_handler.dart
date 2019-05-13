import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/details_page.dart';

Handler detailsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {   // 固定写法
    String goodsId = params['id'].first;
    return DetailsPage(goodsId);
  }
);      // 控制器,是通信间的桥梁
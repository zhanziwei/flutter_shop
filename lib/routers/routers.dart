import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'router_handler.dart';

class Routes {
  static String root = '/';     // 静态方法
  static String detailsPage = '/details';
  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String,List<String >>params) {
        print('ERRROR');
      }
    );

    router.define(detailsPage, handler: detailsHandler);
  }
}
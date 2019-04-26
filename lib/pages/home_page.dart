import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    _getHttp();
    return Center(
      child: Text('商城首页'),
    );
  }
}


Future _getHttp() async {
  try{
    Response response;
    final _data = {'name': '技术胖'};
    response = await Dio().get(
      "https://www.easy-mock.com/mock/"
      "5c60131a4bed3a6342711498/baixing/dabaojian",
      queryParameters: _data
    );

    return print(response);
  } catch(e) {
    return print(e);
  }
}
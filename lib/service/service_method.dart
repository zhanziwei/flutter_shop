// 数据接口读取，所有跟后台请求数据接口的方法都在这个文件中

import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:async';
import '../config/service_url.dart';

Future getHomePageContent() async {
  try{
    print('开始获取首页数据');
    Response response;
    Dio dio = Dio();
    dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
    var formData = {'lon':'115.02932', 'lat':'35.76189'};
    response = await dio.post(servicePath['homePageContext'],data: formData);
    if(response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况');
    }
  } catch(e) {
    return print('ERROR====>$e');
  }
}
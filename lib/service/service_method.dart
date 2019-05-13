// 数据接口读取，所有跟后台请求数据接口的方法都在这个文件中

import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:async';
import '../config/service_url.dart';

Future request(path, {formData}) async {
  try{
    Response response;
    Dio dio = Dio();
    dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
    if(formData != null) {
      response = await dio.post(servicePath[path],data: formData);
    } else {
      response = await dio.post(servicePath[path]);
    }
    if(response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况');
    }
  } catch(e) {
    return print('ERROR====>$e');
  }
}

Future getHomePageContent = request('homePageContent', formData: {'lon':'115.02932','lat':'35.76189'});
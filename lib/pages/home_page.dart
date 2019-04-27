import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController typeController = TextEditingController();
  String showText = '欢迎你来到美好人间';
  @override
  Widget build(BuildContext context) {
    void _choiceAction() {
      print("开始选择你喜欢的类型");
      if(typeController.text.toString() == "") {
        showDialog(context: context, builder: (context) => AlertDialog(title: Text("类型不能为空"),));
      } else {
        getHttp(typeController.text.toString()).then((value) {
          setState(() {
            showText = value['data']['name'].toString();
          });
        });
      }
    }

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('选择你要的类型'),
        ),
        body: Container(
          height: 1000,
          child: Column(
            children: <Widget>[
              TextField(
                controller: typeController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all((10.0)),
                  labelText: '类型类型',
                  helperText: '请输出你要的类型'
                ),
                autofocus: false,
              ),
              RaisedButton(
                onPressed: _choiceAction,
                child: Text('选择完毕'),
              ),
              Text(
                showText,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}


Future getHttp(String typeText) async {
  try{
    Response response;
    var data = {'name': typeText};
    response = await Dio().get(
        "https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian",
        queryParameters:data
    );
    return response.data;
  } catch(e) {
    return print(e);
  }
}


import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/details_info_provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context, child, val) {
        var isLeft = Provide.value<DetailsInfoProvide>(context).isLeft;
        var isRight = Provide.value<DetailsInfoProvide>(context).isRight;

        return Container(
          margin: EdgeInsets.only(top: 15),
          child: Row(
            children: <Widget>[
              _tabBarLeft(context, isLeft),
              _tabBarRight(context, isRight)
            ],
          ),
        );
      },
    );
  }

  Widget _tabBarLeft(BuildContext context, bool isLeft) {
    return InkWell(
      onTap: (){
        Provide.value<DetailsInfoProvide>(context).changeLeftOrRight('left');
      },
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: isLeft?Colors.blue:Colors.black12),
          )
        ),
        child: Text(
          '详情',
          style: TextStyle(color: isLeft?Colors.blue:Colors.black),
        ),
      ),
    );
  }

  Widget _tabBarRight(BuildContext context, bool isRight) {
    return InkWell(
      onTap: (){
        Provide.value<DetailsInfoProvide>(context).changeLeftOrRight('right');
      },
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: isRight?Colors.blue:Colors.black12),
            )
        ),
        child: Text(
          '评论',
          style: TextStyle(color: isRight?Colors.blue:Colors.black),
        ),
      ),
    );
  }
}

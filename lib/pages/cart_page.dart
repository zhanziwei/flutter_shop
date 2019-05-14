import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_shop/model/cartInfo_model.dart';
import 'package:flutter_shop/provide/cart_provide.dart';
import 'cart_pages/cart_item.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List cartInfoList = Provide.value<CartProvide>(context).cartInfoList;
            return ListView.builder(
              itemCount: cartInfoList.length,
              itemBuilder: (context, index) {
                return CartItem(key: key,item: cartInfoList[index]);
              });

          } else {
            return Text('正在加载中');
          }
        }
      ),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'end';
  }
}






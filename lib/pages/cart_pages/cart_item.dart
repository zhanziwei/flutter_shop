import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/model/cartInfo_model.dart';
import 'package:flutter_shop/provide/cart_provide.dart';

class CartItem extends StatelessWidget {
  final CartInfoModel item;

  const CartItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('=======================${item.toString()}');
    return Container(
      margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black12
          )
        )
      ),
      child: Row(
        children: <Widget>[
          _cartCheckButton(),
          _cartImage(),
          _cartName(),
          _cartPrice()
        ],
      ),
    );
  }

  Widget _cartCheckButton() {
    return Container(
      child: Checkbox(value: true, onChanged: (bool val){},activeColor: Colors.blue,),
    );
  }

  Widget _cartImage() {
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12)
      ),
      child: Image.network(item.images),
    );
  }

  Widget _cartName() {
    return Container(
      width: ScreenUtil().setWidth(300),
      padding: EdgeInsets.all(10),
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Text(item.goodsName),
        ],
      ),
    );
  }

  Widget _cartPrice() {
    return Container(
      width: ScreenUtil().setWidth(150),
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Text('￥${item.price}'),
          Container(
            child: InkWell(
              onTap: (){},
              child: Icon(Icons.delete_forever, color: Colors.grey,size: 30,),
            ),
          )
        ],
      ),
    );
  }
}

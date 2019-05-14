import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/child_category_provide.dart';
import 'package:flutter_shop/provide/goods_list_provide.dart';
import 'pages/index_page.dart';
import 'package:provide/provide.dart';
import 'package:fluro/fluro.dart';
import 'routers/routers.dart';
import 'routers/application.dart';
import 'package:flutter_shop/provide/details_info_provide.dart';
import 'package:flutter_shop/provide/cart_provide.dart';


void main(){
  var childCategory = ChildCategoryProvide();
  var providers  = Providers();
  var detailsInfoProvide = DetailsInfoProvide();
  var goodsList = GoodsListProvide();
  var cartProvide = CartProvide();
  final router = Router();
  Routes.configureRoutes(router);
  Application.router = router;

  providers
    ..provide(Provider<ChildCategoryProvide>.value(childCategory))
    ..provide(Provider<GoodsListProvide>.value(goodsList))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
    ..provide(Provider<CartProvide>.value(cartProvide));

  runApp(
    ProviderNode(child: MyApp(), providers: providers)
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        onGenerateRoute: Application.router.generator,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue
        ),
        home: IndexPage(),
      ),
    );
  }
}




// 接口管理文件

const serviceUrl = 'http://v.jspang.com:8088/baixing/';
const servicePath = {
  'homePageContent': serviceUrl + 'wxmini/homePageContent', // 商家首页信息
  'homePageBelowContent': serviceUrl + 'wxmini/homePageBelowConten',  // 商品首页特卖
  'categoryContent': serviceUrl + 'wxmini/getCategory',
  'mallGoods': serviceUrl + 'wxmini/getMallGoods',
  'detailsGoods': serviceUrl + 'wxmini/getGoodDetailById'
};
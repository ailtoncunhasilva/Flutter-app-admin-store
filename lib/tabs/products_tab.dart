import 'package:flutter/material.dart';
import 'package:shoppingdelivery_morenope_admin/widgets/products_tile.dart';

class ProductsTab extends StatefulWidget {
  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Card(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: ProductsTile(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}


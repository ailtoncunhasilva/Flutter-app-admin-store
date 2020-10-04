import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shoppingdelivery_morenope_admin/bloc/orders_bloc.dart';
import 'package:shoppingdelivery_morenope_admin/bloc/user_bloc.dart';
import 'package:shoppingdelivery_morenope_admin/tabs/avisos_tab.dart';
import 'package:shoppingdelivery_morenope_admin/tabs/orders_tab.dart';
import 'package:shoppingdelivery_morenope_admin/tabs/products_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PageController _pageController;
  int _page = 0;

  UserBloc _userBloc;
  OrdersBloc _ordersBloc;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _userBloc = UserBloc();
    _ordersBloc = OrdersBloc();
  }

  @override
  void dispose(){
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.blue[900],
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
            caption: TextStyle(color: Colors.white54)
          )
        ),
        child: BottomNavigationBar(
          currentIndex: _page,
          onTap: (p){
            _pageController.animateToPage(
              p, 
              duration: Duration(milliseconds: 500), 
              curve: Curves.ease
            );
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.announcement),
              title: Text('Avisos')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text('Pedidos')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('produtos')
            ),
          ]
        ),
      ),
      body: SafeArea(
        child: BlocProvider<UserBloc>(
          bloc: _userBloc,
          child: BlocProvider<OrdersBloc>(
            bloc: _ordersBloc,
            child: PageView(
              controller: _pageController,
              onPageChanged: (p){
                setState(() {
                  _page = p;
                });
              },
              children: <Widget>[
                AvisosTab(),
                OrdersTab(),
                ProductsTab()
              ]
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  // ignore: missing_return
  Widget _buildFloating(){
    switch(_page){
      case 0:
      return null;
      break;
      case 1:
      return SpeedDial(
        child: Icon(Icons.sort),
        backgroundColor: Colors.blue[900],
        overlayOpacity: 0.4,
        overlayColor: Colors.black,
        children: [
          SpeedDialChild(
            child: Icon(Icons.arrow_downward, color: Colors.blue[900]),
            backgroundColor: Colors.white,
            label: 'Concluídos Abaixo',
            labelStyle: TextStyle(fontSize: 14),
            onTap: (){
              _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
            }
          ),
          SpeedDialChild(
            child: Icon(Icons.arrow_upward, color: Colors.blue[900]),
            backgroundColor: Colors.white,
            label: 'Concluídos Acima',
            labelStyle: TextStyle(fontSize: 14),
            onTap: (){
              _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
            }
          ),
        ],
      );
      break;
      case 2:
      return null;
      break;
    }
  }
}
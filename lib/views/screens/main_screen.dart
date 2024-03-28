import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:shopworm_web_admin/views/screens/side_bar_screen/categories_screen.dart';
import 'package:shopworm_web_admin/views/screens/side_bar_screen/dashboard_screen.dart';
import 'package:shopworm_web_admin/views/screens/side_bar_screen/orders_screen.dart';
import 'package:shopworm_web_admin/views/screens/side_bar_screen/product_screen.dart';
import 'package:shopworm_web_admin/views/screens/side_bar_screen/upload_banner_screen.dart';
import 'package:shopworm_web_admin/views/screens/side_bar_screen/vendors_screen.dart';
import 'package:shopworm_web_admin/views/screens/side_bar_screen/withdrawl_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedItem = DashboardScreen();

  screenSelector(item) {
    switch(item.route) {
      case DashboardScreen.routeName:
        setState(() {
          _selectedItem = DashboardScreen();
        });
        break;
      case VendorsScreen.routeName:
        setState(() {
          _selectedItem = VendorsScreen();
        });
        break;
      case WithdrawlScreen.routeName:
        setState(() {
          _selectedItem = WithdrawlScreen();
        });
        break;
      case OrderScreen.routeName:
        setState(() {
          _selectedItem = OrderScreen();
        });
        break;
      case CategoriesScreen.routeName:
        setState(() {
          _selectedItem = CategoriesScreen();
        });
        break;
      case ProductScreen.routeName:
        setState(() {
          _selectedItem = ProductScreen();
        });
        break;
      case UploadBannerScreen.routeName:
        setState(() {
          _selectedItem = UploadBannerScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.yellow.shade900,
          titleTextStyle: TextStyle(color: Colors.white , fontSize: 19 , fontWeight: FontWeight.bold),
          title: Text('Management'),
        ),
        sideBar: SideBar(
          items: [
            AdminMenuItem(
              title: 'Dashboard',
              icon: Icons.dashboard,
              route: DashboardScreen.routeName,
            ),
            AdminMenuItem(
              title: 'Vendors',
              icon: CupertinoIcons.person_3,
              route: VendorsScreen.routeName,
            ),
            AdminMenuItem(
              title: 'Withdrawl',
              icon: CupertinoIcons.money_dollar,
              route: WithdrawlScreen.routeName,
            ),
            AdminMenuItem(
              title: 'Orders',
              icon: CupertinoIcons.cart,
              route: OrderScreen.routeName,
            ),
            AdminMenuItem(
              title: 'Categories',
              icon: Icons.category,
              route: CategoriesScreen.routeName,
            ),
            AdminMenuItem(
              title: 'Products',
              icon: Icons.shop,
              route: ProductScreen.routeName,
            ),
            AdminMenuItem(
              title: 'Upload Banner',
              icon: CupertinoIcons.add,
              route: UploadBannerScreen.routeName,
            ),
          ],
          selectedRoute: '', onSelected: (item) {
            screenSelector(item);
        },
          header: Container(
            height: 50,
            width: double.infinity,
            color: const Color(0xff444444),
            child: const Center(
              child: Text(
                'Shopworm Admin Panel',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          footer: Container(
            height: 50,
            width: double.infinity,
            color: const Color(0xff444444),
            child: const Center(
              child: Text(
                'footer',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),


        body: _selectedItem);
  }
}

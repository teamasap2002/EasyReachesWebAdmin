import 'package:flutter/material.dart';
import 'package:shopworm_web_admin/views/screens/side_bar_screen/widgets/orders_widget.dart';

class OrderScreen extends StatelessWidget {

  static const String routeName = '\OrderScreen';



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Manage Orders',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          OrdersWidget(),

        ],
      ),
    );
  }
}

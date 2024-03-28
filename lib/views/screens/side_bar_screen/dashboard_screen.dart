
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // StreamBuilder<QuerySnapshot>(
                  //   stream: FirebaseFirestore.instance.collection('buyers').snapshots(),
                  //   builder: (context, snapshot) {
                  //     if (!snapshot.hasData) return CircularProgressIndicator();
                  //     int totalUsers = snapshot.data!.size;
                  //     return DashboardItem(title: 'Total Users', count: totalUsers.toString());
                  //   },
                  // ),
                  // StreamBuilder<QuerySnapshot>(
                  //   stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
                  //   builder: (context, snapshot) {
                  //     if (!snapshot.hasData) return CircularProgressIndicator();
                  //     int totalVendors = snapshot.data!.size;
                  //     return DashboardItem(title: 'Total Vendors', count: totalVendors.toString());
                  //   },
                  // ),
                  // StreamBuilder<QuerySnapshot>(
                  //   stream: FirebaseFirestore.instance.collection('products').snapshots(),
                  //   builder: (context, snapshot) {
                  //     if (!snapshot.hasData) return CircularProgressIndicator();
                  //     int totalProducts = snapshot.data!.size;
                  //     return DashboardItem(title: 'Total Products', count: totalProducts.toString());
                  //   },
                  // ),
                  // StreamBuilder<QuerySnapshot>(
                  //   stream: FirebaseFirestore.instance.collection('orders').snapshots(),
                  //   builder: (context, snapshot) {
                  //     if (!snapshot.hasData) return CircularProgressIndicator();
                  //     int totalOrders = snapshot.data!.size;
                  //     return DashboardItem(title: 'Total Orders', count: totalOrders.toString());
                  //   },
                  // ),

                  // StreamBuilder<QuerySnapshot>(
                  //   stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                  //   builder: (context, snapshot) {
                  //     if (!snapshot.hasData) return CircularProgressIndicator();
                  //     int totalCategories = snapshot.data!.size;
                  //     return DashboardItem(title: 'Total Categories', count: totalCategories.toString());
                  //   },
                  // ),

                  Text("analytics not yet uploaded"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final String title;
  final String count;

  const DashboardItem({
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            count,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

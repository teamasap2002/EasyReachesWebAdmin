

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        // Sort orders based on status, 'incomplete' first
        documents.sort((a, b) {
          final statusA = (a.data() as Map<String, dynamic>)['status'];
          final statusB = (b.data() as Map<String, dynamic>)['status'];
          if (statusA == 'incomplete' && statusB != 'incomplete') {
            return -1;
          } else if (statusA != 'incomplete' && statusB == 'incomplete') {
            return 1;
          } else {
            return 0;
          }
        });

        // Group orders based on status
        Map<String, List<DocumentSnapshot>> ordersByStatus = {};
        documents.forEach((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final String status = data['status'];
          if (!ordersByStatus.containsKey(status)) {
            ordersByStatus[status] = [];
          }
          ordersByStatus[status]!.add(doc);
        });

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: ordersByStatus.keys.map((status) {
              return _buildDataTable(status, ordersByStatus[status]!);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildDataTable(String status, List<DocumentSnapshot> orders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Orders with Status: $status',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20,
            columns: [
              DataColumn(label: Text('#', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('User ID', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Product Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Vendor Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Price', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Action', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            ],
            rows: orders.asMap().entries.map((entry) {
              final int index = entry.key;
              final DocumentSnapshot doc = entry.value;
              final data = doc.data() as Map<String, dynamic>;
              final DateTime time = (data['time'] as Timestamp).toDate();
              final formattedTime = DateFormat('dd/MM/yyyy').format(time);
              final String orderId = doc.id;
              final String currentStatus = data['status'];

              return DataRow(cells: [
                DataCell(Text('${index + 1}')), // Adding numbering
                DataCell(Text(data['userId'])),
                DataCell(Text(data['productName'])),
                DataCell(Text(data['vendorName'])),
                DataCell(Text(data['productPrice'].toString())),
                DataCell(Text(formattedTime)), // Displaying time in DD/MM/YYYY format
                DataCell(Text(currentStatus)),
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      // Update status
                      String newStatus = currentStatus == 'complete' ? 'incomplete' : 'complete';
                      FirebaseFirestore.instance.collection('orders').doc(orderId).update({'status': newStatus});
                    },
                    child: Text(currentStatus == 'complete' ? 'Make Incomplete' : 'Make Complete'),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VendorWidget extends StatefulWidget {
  const VendorWidget({super.key});

  @override
  State<VendorWidget> createState() => _VendorWidgetState();
}

class _VendorWidgetState extends State<VendorWidget> {
  Future<void> deleteVendor(String vendorId) async {
    try {
      await FirebaseFirestore.instance.collection('vendors').doc(vendorId).delete();
      print('Vendor deleted successfully');
    } catch (e) {
      print('Error deleting vendor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final docs = snapshot.data?.docs;
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              columnSpacing: 20,
              columns: [
                DataColumn(label: Text('Logo', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Business Name', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('City', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('State', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Action', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
              ],
              rows: docs!.map((doc) {
                return DataRow(cells: [
                  DataCell(Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(height: 50, width: 50, child: Image.network(doc['image'])),
                  )),
                  DataCell(Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(doc['businessName']),
                  )),
                  DataCell(Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(doc['vendorCity']),
                  )),
                  DataCell(Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(doc['vendorState']),
                  )),
                  DataCell(
                    ElevatedButton(
                      onPressed: () {
                        // Prompt user for confirmation before deleting
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete this vendor?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Delete vendor
                                    deleteVendor(doc.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Delete'),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

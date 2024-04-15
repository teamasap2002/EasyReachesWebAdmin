//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class VendorWidget extends StatefulWidget {
//   const VendorWidget({Key? key}) : super(key: key);
//
//   @override
//   State<VendorWidget> createState() => _VendorWidgetState();
// }
//
// class _VendorWidgetState extends State<VendorWidget> {
//   late TextEditingController _businessNameController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _cityController;
//   late TextEditingController _stateController;
//   String? _selectedProductId;
//
//   @override
//   void initState() {
//     super.initState();
//     _businessNameController = TextEditingController();
//     _descriptionController = TextEditingController();
//     _cityController = TextEditingController();
//     _stateController = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     _businessNameController.dispose();
//     _descriptionController.dispose();
//     _cityController.dispose();
//     _stateController.dispose();
//     super.dispose();
//   }
//
//   Future<List<DocumentSnapshot>> fetchProductsByCategoryId(String categoryId) async {
//     final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('products')
//         .where('categoryId', isEqualTo: categoryId)
//         .get();
//     return querySnapshot.docs;
//   }
//
//   Future<void> updateVendor(String vendorId) async {
//     try {
//       if (_selectedProductId == null) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Error'),
//               content: Text('Please select a product before updating.'),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//         return;
//       }
//
//       await FirebaseFirestore.instance.collection('vendors').doc(vendorId).update({
//         'businessName': _businessNameController.text,
//         'description': _descriptionController.text,
//         'vendorCity': _cityController.text,
//         'vendorState': _stateController.text,
//         'productId': _selectedProductId,
//       });
//       print('Vendor details updated successfully');
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Success'),
//             content: Text('Vendor details updated successfully'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     } catch (e) {
//       print('Error updating vendor details: $e');
//     }
//   }
//
//   Future<void> deleteVendor(BuildContext context, String vendorId) async {
//     try {
//       if (vendorId.isNotEmpty) {
//         await FirebaseFirestore.instance.collection('vendors').doc(vendorId).delete();
//         print('Vendor deleted successfully');
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Success'),
//               content: Text('Vendor deleted successfully'),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       } else {
//         print('Error: Vendor ID is empty');
//       }
//     } catch (e) {
//       print('Error deleting vendor: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
//       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         final docs = snapshot.data?.docs;
//         return SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             child: DataTable(
//               columnSpacing: 20,
//               columns: [
//                 DataColumn(label: Text('Logo', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('Business Name', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('City', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('State', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('Product Name', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('Category Name', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('Action', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
//               ],
//               rows: docs!.map((doc) {
//                 return DataRow(cells: [
//                   DataCell(Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: SizedBox(height: 50, width: 50, child: Image.network(doc['image'])),
//                   )),
//                   DataCell(Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: Text(doc['businessName']),
//                   )),
//                   DataCell(Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: Text(doc['vendorCity']),
//                   )),
//                   DataCell(Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: Text(doc['vendorState']),
//                   )),
//                   DataCell(StreamBuilder<DocumentSnapshot>(
//                     stream: doc['productId'] != null && doc['productId'] != ''
//                         ? FirebaseFirestore.instance.collection('products').doc(doc['productId']).snapshots()
//                         : Stream.empty(),
//                     builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//                       if (snapshot.hasData && snapshot.data!.exists) {
//                         var productName = snapshot.data!['productName'];
//                         return Padding(
//                           padding: const EdgeInsets.all(5.0),
//                           child: Text(productName),
//                         );
//                       }
//                       return SizedBox();
//                     },
//                   )),
//                   DataCell(StreamBuilder<DocumentSnapshot>(
//                     stream: doc['categoryId'] != null && doc['categoryId'] != ''
//                         ? FirebaseFirestore.instance.collection('categories').doc(doc['categoryId']).snapshots()
//                         : Stream.empty(),
//                     builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//                       if (snapshot.hasData && snapshot.data!.exists) {
//                         var categoryName = snapshot.data!['categoryName'];
//                         return Padding(
//                           padding: const EdgeInsets.all(5.0),
//                           child: Text(categoryName),
//                         );
//                       }
//                       return SizedBox();
//                     },
//                   )),
//                   DataCell(
//                     Row(
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             _businessNameController.text = doc['businessName'];
//                             _descriptionController.text = doc['description'];
//                             _cityController.text = doc['vendorCity'];
//                             _stateController.text = doc['vendorState'];
//                             _selectedProductId = doc['productId']; // Set initial value
//
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return StatefulBuilder(
//                                   builder: (context, setState) {
//                                     return AlertDialog(
//                                       title: Text('Edit Vendor Details'),
//                                       content: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           TextField(
//                                             controller: _businessNameController,
//                                             decoration: InputDecoration(labelText: 'Business Name'),
//                                           ),
//                                           TextField(
//                                             controller: _descriptionController,
//                                             decoration: InputDecoration(labelText: 'Description'),
//                                           ),
//                                           TextField(
//                                             controller: _cityController,
//                                             decoration: InputDecoration(labelText: 'City'),
//                                           ),
//                                           TextField(
//                                             controller: _stateController,
//                                             decoration: InputDecoration(labelText: 'State'),
//                                           ),
//                                           FutureBuilder<List<DocumentSnapshot>>(
//                                             future: fetchProductsByCategoryId(doc['categoryId']),
//                                             builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
//                                               if (snapshot.connectionState == ConnectionState.waiting) {
//                                                 return CircularProgressIndicator();
//                                               }
//                                               if (snapshot.hasError) {
//                                                 return Text('Error: ${snapshot.error}');
//                                               }
//                                               final products = snapshot.data!;
//                                               return DropdownButtonFormField<String>(
//                                                 value: _selectedProductId,
//                                                 onChanged: (newValue) {
//                                                   setState(() {
//                                                     _selectedProductId = newValue;
//                                                   });
//                                                 },
//                                                 items: products.map((product) {
//                                                   return DropdownMenuItem<String>(
//                                                     value: product.id,
//                                                     child: Text(product['productName']),
//                                                   );
//                                                 }).toList(),
//                                                 hint: Text('Select Product'),
//                                               );
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                       actions: <Widget>[
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.of(context).pop();
//                                           },
//                                           child: Text('Cancel'),
//                                         ),
//                                         TextButton(
//                                           onPressed: () {
//                                             updateVendor(doc.id);
//                                             Navigator.of(context).pop();
//                                           },
//                                           child: Text('Update'),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//                               },
//                             );
//                           },
//                           child: Text('Edit'),
//                         ),
//                         SizedBox(width: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: Text('Confirm Delete'),
//                                   content: Text('Are you sure you want to delete this vendor?'),
//                                   actions: <Widget>[
//                                     TextButton(
//                                       onPressed: () {
//                                         deleteVendor(context, doc.id); // Pass context here
//                                         Navigator.of(context).pop();
//                                       },
//                                       child: Text('Delete'),
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.of(context).pop();
//                                       },
//                                       child: Text('Cancel'),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           },
//                           child: Text('Delete'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ]);
//               }).toList(),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VendorWidget extends StatefulWidget {
  const VendorWidget({Key? key}) : super(key: key);

  @override
  State<VendorWidget> createState() => _VendorWidgetState();
}

class _VendorWidgetState extends State<VendorWidget> {
  late TextEditingController _businessNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  String? _selectedProductId;

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<List<DocumentSnapshot>> fetchProductsByCategoryId(String categoryId) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> fetchAllProducts(String categoryId) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .get();
    return querySnapshot.docs;
  }

  Future<void> updateVendor(String vendorId) async {
    try {
      if (_selectedProductId == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please select a product before updating.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      await FirebaseFirestore.instance.collection('vendors').doc(vendorId).update({
        'businessName': _businessNameController.text,
        'description': _descriptionController.text,
        'vendorCity': _cityController.text,
        'vendorState': _stateController.text,
        'productId': _selectedProductId,
      });
      print('Vendor details updated successfully');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Vendor details updated successfully'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error updating vendor details: $e');
    }
  }

  Future<void> deleteVendor(BuildContext context, String vendorId) async {
    try {
      if (vendorId.isNotEmpty) {
        await FirebaseFirestore.instance.collection('vendors').doc(vendorId).delete();
        print('Vendor deleted successfully');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Vendor deleted successfully'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Error: Vendor ID is empty');
      }
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
                DataColumn(label: Text('Product Name', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Category Name', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Action', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
              ],
              rows: docs!.map((doc) {
                final vendorData = doc.data() as Map<String, dynamic>;
                return DataRow(cells: [
                  DataCell(Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(height: 50, width: 50, child: Image.network(vendorData['image'])),
                  )),
                  DataCell(Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(vendorData['businessName']),
                  )),
                  DataCell(Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(vendorData['vendorCity']),
                  )),
                  DataCell(Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(vendorData['vendorState']),
                  )),
                  DataCell(StreamBuilder<DocumentSnapshot>(
                    stream: vendorData['productId'] != null && vendorData['productId'] != ''
                        ? FirebaseFirestore.instance.collection('products').doc(vendorData['productId']).snapshots()
                        : Stream.empty(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData && snapshot.data!.exists) {
                        var productName = snapshot.data!['productName'];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(productName),
                        );
                      }
                      return SizedBox();
                    },
                  )),
                  DataCell(StreamBuilder<DocumentSnapshot>(
                    stream: vendorData['categoryId'] != null && vendorData['categoryId'] != ''
                        ? FirebaseFirestore.instance.collection('categories').doc(vendorData['categoryId']).snapshots()
                        : Stream.empty(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData && snapshot.data!.exists) {
                        var categoryName = snapshot.data!['categoryName'];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(categoryName),
                        );
                      }
                      return SizedBox();
                    },
                  )),
                  DataCell(
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _businessNameController.text = vendorData['businessName'];
                            _descriptionController.text = vendorData['description'];
                            _cityController.text = vendorData['vendorCity'];
                            _stateController.text = vendorData['vendorState'];
                            _selectedProductId = vendorData['productId']; // Set initial value

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text('Edit Vendor Details'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: _businessNameController,
                                            decoration: InputDecoration(labelText: 'Business Name'),
                                          ),
                                          TextField(
                                            controller: _descriptionController,
                                            decoration: InputDecoration(labelText: 'Description'),
                                          ),
                                          TextField(
                                            controller: _cityController,
                                            decoration: InputDecoration(labelText: 'City'),
                                          ),
                                          TextField(
                                            controller: _stateController,
                                            decoration: InputDecoration(labelText: 'State'),
                                          ),
                                          FutureBuilder<List<DocumentSnapshot>>(
                                            future: _selectedProductId != null && _selectedProductId!.isNotEmpty
                                                ? fetchProductsByCategoryId(vendorData['categoryId'])
                                                : fetchAllProducts(vendorData['categoryId']), // Fetch all products when _selectedProductId is null or empty
                                            builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              }
                                              if (snapshot.hasError) {
                                                return Text('Error: ${snapshot.error}');
                                              }
                                              final products = snapshot.data!;
                                              return DropdownButtonFormField<String>(
                                                value: _selectedProductId,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _selectedProductId = newValue;
                                                  });
                                                },
                                                items: products.map((product) {
                                                  return DropdownMenuItem<String>(
                                                    value: product.id, // Use document ID as the value
                                                    child: Text(product['productName']),
                                                  );
                                                }).toList(),
                                                hint: Text('Select Product'),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            updateVendor(doc.id);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Update'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Text('Edit'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Delete'),
                                  content: Text('Are you sure you want to delete this vendor?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        deleteVendor(context, doc.id); // Pass context here
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Delete'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text('Delete'),
                        ),
                      ],
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

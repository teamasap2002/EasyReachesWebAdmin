//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class ProductWidget extends StatefulWidget {
//   const ProductWidget({Key? key}) : super(key: key);
//
//   @override
//   State<ProductWidget> createState() => _ProductWidgetState();
// }
//
// class _ProductWidgetState extends State<ProductWidget> {
//   Future<void> deleteProduct(String productId) async {
//     try {
//       await FirebaseFirestore.instance.collection('products').doc(productId).delete();
//       print('Product deleted successfully');
//     } catch (e) {
//       print('Error deleting product: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance.collection('products').snapshots(),
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
//                 DataColumn(label: Text('Image', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('Name', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('Price', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('Description', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('Category', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('Action', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
//               ],
//               rows: docs!.map((doc) {
//                 return DataRow(cells: [
//                   DataCell(SizedBox(height: 50, width: 50, child: Image.network(doc['image']))),
//                   DataCell(Text(doc['productName'])),
//                   DataCell(Text(doc['productPrice'])),
//                   DataCell(Text(doc['productDescription'])),
//                   DataCell(
//                     FutureBuilder(
//                       future: FirebaseFirestore.instance.collection('categories').doc(doc['categoryId']).get(),
//                       builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> categorySnapshot) {
//                         if (categorySnapshot.connectionState == ConnectionState.waiting) {
//                           return CircularProgressIndicator();
//                         } else if (categorySnapshot.hasError) {
//                           return Text('Error: ${categorySnapshot.error}');
//                         } else {
//                           var categoryName = categorySnapshot.data?.get('categoryName') ?? 'N/A';
//                           return Text(categoryName);
//                         }
//                       },
//                     ),
//                   ),
//                   DataCell(
//                     ElevatedButton(
//                       onPressed: () {
//                         // Prompt user for confirmation before deleting
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: Text('Confirm Delete'),
//                               content: Text('Are you sure you want to delete this product?'),
//                               actions: <Widget>[
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Text('Cancel'),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     // Delete product
//                                     deleteProduct(doc.id);
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Text('Delete'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                       child: Text('Delete'),
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

class ProductWidget extends StatefulWidget {
  const ProductWidget({Key? key}) : super(key: key);

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();
      print('Product deleted successfully');
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  Future<void> editProduct(String productId, String productName, String productPrice, String productDescription) async {
    nameController.text = productName;
    priceController.text = productPrice;
    descriptionController.text = productDescription;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection('products').doc(productId).update({
                    'productName': nameController.text,
                    'productPrice': priceController.text,
                    'productDescription': descriptionController.text,
                  });
                  print('Product updated successfully');
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error updating product: $e');
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
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
                DataColumn(label: Text('Image', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Name', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Price', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Description', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Category', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Action', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
              ],
              rows: docs!.map((doc) {
                return DataRow(cells: [
                  DataCell(SizedBox(height: 50, width: 50, child: Image.network(doc['image']))),
                  DataCell(Text(doc['productName'])),
                  DataCell(Text(doc['productPrice'])),
                  DataCell(Text(doc['productDescription'])),
                  DataCell(
                    FutureBuilder(
                      future: FirebaseFirestore.instance.collection('categories').doc(doc['categoryId']).get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> categorySnapshot) {
                        if (categorySnapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (categorySnapshot.hasError) {
                          return Text('Error: ${categorySnapshot.error}');
                        } else {
                          var categoryName = categorySnapshot.data?.get('categoryName') ?? 'N/A';
                          return Text(categoryName);
                        }
                      },
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Edit product
                            editProduct(doc.id, doc['productName'], doc['productPrice'], doc['productDescription']);
                          },
                          child: Text('Edit'),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Delete product
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Delete'),
                                  content: Text('Are you sure you want to delete this product?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteProduct(doc.id);
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

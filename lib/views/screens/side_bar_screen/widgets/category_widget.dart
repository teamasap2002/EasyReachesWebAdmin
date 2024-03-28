// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class CategoryWidget extends StatelessWidget {
//   const CategoryWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> _categoriesStream =
//         FirebaseFirestore.instance.collection('categories').snapshots();
//
//     return StreamBuilder<QuerySnapshot>(
//       stream: _categoriesStream,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Something went wrong');
//         }
//
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: Colors.cyan,
//             ),
//           );
//         }
//
//         return GridView.builder(
//           shrinkWrap: true,
//             itemCount: snapshot.data!.size,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 6, mainAxisSpacing: 8, crossAxisSpacing: 8),
//             itemBuilder: (context, index) {
//               final categoryData = snapshot.data!.docs[index];
//               return Column(
//                 children: [
//                   SizedBox(
//                     height: 100,
//                     width: 100,
//                     child: Image.network(categoryData['image']),
//                   ),
//                   Text(categoryData['categoryName']),
//                 ],
//               );
//             });
//       },
//     );
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoriesStream =
    FirebaseFirestore.instance.collection('categories').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _categoriesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.cyan,
            ),
          );
        }

        // Extract category data from snapshot
        List<Map<String, dynamic>> categoryDataList =
        snapshot.data!.docs.map((DocumentSnapshot document) {
          return (document.data() as Map<String, dynamic>);
        }).toList();

        // Function to handle category deletion
        Future<void> deleteCategory(String categoryId) async {
          try {
            await FirebaseFirestore.instance.collection('categories').doc(categoryId).delete();
          } catch (error) {
            print('Error deleting category: $error');
          }
        }

        // Define DataTable rows
        final DataTableRows = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width, // Set width to screen width
            child: DataTable(
              columnSpacing: 0, // Set columnSpacing to zero to occupy complete width
              columns: [
                DataColumn(label: Text('Image')),
                DataColumn(label: Text('Category Name')),
                DataColumn(label: Text('Delete')),
              ],
              rows: categoryDataList.map((categoryData) {
                return DataRow(cells: [
                  DataCell(
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.network(categoryData['image']),
                    ),
                  ),
                  DataCell(
                    Text(categoryData['categoryName']),
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete ${categoryData['categoryName']}?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteCategory(categoryData['categoryName']);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        );

        // Return Column widget to display DataTableRows
        return Column(
          children: [
            DataTableRows,
          ],
        );
      },
    );
  }
}

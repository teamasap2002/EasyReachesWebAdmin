// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:shopworm_web_admin/views/screens/side_bar_screen/widgets/product_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:file_picker/file_picker.dart';
//
// class ProductScreen extends StatefulWidget {
//   static const String routeName = '/product_screen';
//
//   @override
//   _ProductScreenState createState() => _ProductScreenState();
// }
//
// class _ProductScreenState extends State<ProductScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//
//   dynamic _image;
//   String? _selectedCategory;
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   TextEditingController _productNameController = TextEditingController();
//   TextEditingController _priceController = TextEditingController();
//   TextEditingController _descriptionController = TextEditingController();
//
//   void _pickImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: false,
//       type: FileType.image,
//     );
//
//     if (result != null) {
//       setState(() {
//         _image = result.files.first.bytes;
//       });
//     }
//   }
//
//   Future<String> _uploadProductToStorage(dynamic image, String fileName) async {
//     Reference ref = _storage.ref().child('productImages').child(fileName);
//
//     UploadTask uploadTask = ref.putData(image);
//
//     await uploadTask.whenComplete(() => print('Product image uploaded'));
//
//     String downloadUrl = await ref.getDownloadURL();
//     return downloadUrl;
//   }
//
//   Future<void> _uploadProduct() async {
//     if (_formKey.currentState!.validate()) {
//       // Validate form fields
//       EasyLoading.show(status: 'Uploading Product...');
//       String imageUrl = await _uploadProductToStorage(_image, _productNameController.text);
//
//       // Get the count of existing products to generate a unique product ID
//       int productId = await _firestore.collection("products").get().then((value) => value.docs.length + 1);
//
//       // Upload product details to Firestore
//       await _firestore.collection("products").doc(productId.toString()).set({
//         'image': imageUrl,
//         'productName': _productNameController.text,
//         'productId': productId,
//         'productPrice': _priceController.text,
//         'productDescription': _descriptionController.text,
//         'categoryName': _selectedCategory,
//       });
//
//       EasyLoading.dismiss();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Product added successfully')),
//       );
//
//       setState(() {
//         _image = null;
//         _formKey.currentState!.reset();
//         _productNameController.clear();
//         _priceController.clear();
//         _descriptionController.clear();
//         _selectedCategory = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Product'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 InkWell(
//                   onTap: _pickImage,
//                   child: Container(
//                     height: 200,
//                     width: 200,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       border: Border.all(color: Colors.grey),
//                     ),
//                     child: _image != null
//                         ? Image.memory(
//                       _image,
//                       fit: BoxFit.cover,
//                     )
//                         : Center(child: Text('Tap to select image')),
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Expanded(
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextFormField(
//                           controller: _productNameController,
//                           decoration: InputDecoration(labelText: 'Product Name'),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter product name';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 10),
//                         TextFormField(
//                           controller: _priceController,
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(labelText: 'Product Price'),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter product price';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 10),
//                         TextFormField(
//                           controller: _descriptionController,
//                           maxLines: 3,
//                           decoration: InputDecoration(labelText: 'Product Description'),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter product description';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 10),
//                         StreamBuilder<QuerySnapshot>(
//                           stream: FirebaseFirestore.instance.collection('categories').snapshots(),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState == ConnectionState.waiting) {
//                               return CircularProgressIndicator();
//                             }
//                             if (snapshot.hasError) {
//                               return Text('Error: ${snapshot.error}');
//                             }
//                             final categories = snapshot.data!.docs;
//                             List<String> categoryNames = categories.map((doc) => doc['categoryName']).cast<String>().toList();
//                             return DropdownButtonFormField<String>(
//                               value: _selectedCategory,
//                               items: categoryNames.map((categoryName) {
//                                 return DropdownMenuItem<String>(
//                                   value: categoryName,
//                                   child: Text(categoryName),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   _selectedCategory = value;
//                                 });
//                               },
//                               decoration: InputDecoration(labelText: 'Product Category'),
//                               validator: (value) {
//                                 if (value == null) {
//                                   return 'Please select product category';
//                                 }
//                                 return null;
//                               },
//                             );
//                           },
//                         ),
//
//
//
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: _uploadProduct,
//                 child: Text('Save'),
//               ),
//             ),
//             SizedBox(height: 20),
//             Divider(color: Colors.grey,),
//             SizedBox(height: 20),
//             ProductWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//


//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:shopworm_web_admin/views/screens/side_bar_screen/widgets/product_widget.dart';
//
// class ProductScreen extends StatefulWidget {
//   static const String routeName = '/product_screen';
//
//   @override
//   _ProductScreenState createState() => _ProductScreenState();
// }
//
// class _ProductScreenState extends State<ProductScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//
//   dynamic _image;
//   String? _selectedCategory;
//   String? _selectedVendor;
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   TextEditingController _productNameController = TextEditingController();
//   TextEditingController _priceController = TextEditingController();
//   TextEditingController _descriptionController = TextEditingController();
//
//   void _pickImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: false,
//       type: FileType.image,
//     );
//
//     if (result != null) {
//       setState(() {
//         _image = result.files.first.bytes;
//       });
//     }
//   }
//
//   Future<String> _uploadProductToStorage(dynamic image, String fileName) async {
//     Reference ref = _storage.ref().child('productImages').child(fileName);
//
//     UploadTask uploadTask = ref.putData(image);
//
//     await uploadTask.whenComplete(() => print('Product image uploaded'));
//
//     String downloadUrl = await ref.getDownloadURL();
//     return downloadUrl;
//   }
//
//   Future<void> _uploadProduct() async {
//     if (_formKey.currentState!.validate()) {
//       // Validate form fields
//       EasyLoading.show(status: 'Uploading Product...');
//       String imageUrl = await _uploadProductToStorage(_image, _productNameController.text);
//
//       // Get the count of existing products to generate a unique product ID
//       int productId = await _firestore.collection("products").get().then((value) => value.docs.length + 1);
//
//       // Upload product details to Firestore
//       await _firestore.collection("products").doc(productId.toString()).set({
//         'image': imageUrl,
//         'productName': _productNameController.text,
//         'productId': productId,
//         'productPrice': _priceController.text,
//         'productDescription': _descriptionController.text,
//         'categoryName': _selectedCategory,
//         'vendorName': _selectedVendor,
//       });
//
//       EasyLoading.dismiss();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Product added successfully')),
//       );
//
//       setState(() {
//         _image = null;
//         _formKey.currentState!.reset();
//         _productNameController.clear();
//         _priceController.clear();
//         _descriptionController.clear();
//         _selectedCategory = null;
//         _selectedVendor = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Product'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 InkWell(
//                   onTap: _pickImage,
//                   child: Container(
//                     height: 200,
//                     width: 200,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       border: Border.all(color: Colors.grey),
//                     ),
//                     child: _image != null
//                         ? Image.memory(
//                       _image,
//                       fit: BoxFit.cover,
//                     )
//                         : Center(child: Text('Tap to select image')),
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Expanded(
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextFormField(
//                           controller: _productNameController,
//                           decoration: InputDecoration(labelText: 'Product Name'),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter product name';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 10),
//                         TextFormField(
//                           controller: _priceController,
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(labelText: 'Product Price'),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter product price';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 10),
//                         TextFormField(
//                           controller: _descriptionController,
//                           maxLines: 3,
//                           decoration: InputDecoration(labelText: 'Product Description'),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter product description';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 10),
//                         StreamBuilder<QuerySnapshot>(
//                           stream: FirebaseFirestore.instance.collection('categories').snapshots(),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState == ConnectionState.waiting) {
//                               return CircularProgressIndicator();
//                             }
//                             if (snapshot.hasError) {
//                               return Text('Error: ${snapshot.error}');
//                             }
//                             final categories = snapshot.data!.docs;
//                             List<String> categoryNames = categories.map((doc) => doc['categoryName']).cast<String>().toList();
//                             return DropdownButtonFormField<String>(
//                               value: _selectedCategory,
//                               items: categoryNames.map((categoryName) {
//                                 return DropdownMenuItem<String>(
//                                   value: categoryName,
//                                   child: Text(categoryName),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   _selectedCategory = value;
//                                 });
//                               },
//                               decoration: InputDecoration(labelText: 'Product Category'),
//                               validator: (value) {
//                                 if (value == null) {
//                                   return 'Please select product category';
//                                 }
//                                 return null;
//                               },
//                             );
//                           },
//                         ),
//                         SizedBox(height: 10),
//                         StreamBuilder<QuerySnapshot>(
//                           stream: FirebaseFirestore.instance.collection('vendors').where('categoryName', isEqualTo: _selectedCategory).snapshots(),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState == ConnectionState.waiting) {
//                               return CircularProgressIndicator();
//                             }
//                             if (snapshot.hasError) {
//                               return Text('Error: ${snapshot.error}');
//                             }
//                             final vendors = snapshot.data!.docs;
//                             List<String> vendorNames = vendors.map((doc) => doc['businessName']).cast<String>().toList();
//                             return DropdownButtonFormField<String>(
//                               value: _selectedVendor,
//                               items: vendorNames.map((vendorName) {
//                                 return DropdownMenuItem<String>(
//                                   value: vendorName,
//                                   child: Text(vendorName),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   _selectedVendor = value;
//                                 });
//                               },
//                               decoration: InputDecoration(labelText: 'Select Vendor'),
//                               validator: (value) {
//                                 if (value == null) {
//                                   return 'Please select a vendor';
//                                 }
//                                 return null;
//                               },
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: _uploadProduct,
//                 child: Text('Save'),
//               ),
//             ),
//             SizedBox(height: 20),
//             Divider(color: Colors.grey,),
//             SizedBox(height: 20),
//             ProductWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shopworm_web_admin/views/screens/side_bar_screen/widgets/product_widget.dart';

class ProductScreen extends StatefulWidget {
  static const String routeName = '/product_screen';

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  dynamic _image;
  String? _selectedCategoryId;
  String? _selectedVendorId;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
      });
    }
  }

  Future<String> _uploadProductToStorage(dynamic image, String fileName) async {
    Reference ref = _storage.ref().child('productImages').child(fileName);

    UploadTask uploadTask = ref.putData(image);

    await uploadTask.whenComplete(() => print('Product image uploaded'));

    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate()) {
      // Validate form fields
      EasyLoading.show(status: 'Uploading Product...');
      String imageUrl = await _uploadProductToStorage(_image, _productNameController.text);

      // Upload product details to Firestore with automatic unique ID
      DocumentReference productRef = await _firestore.collection("products").add({
        'image': imageUrl,
        'productName': _productNameController.text,
        'productPrice': _priceController.text,
        'productDescription': _descriptionController.text,
        'categoryId': _selectedCategoryId, // Store categoryId instead of categoryName
        'vendorId': _selectedVendorId,
      });

      String productId = productRef.id; // Get the auto-generated unique ID

      // Update the product document with the generated ID
      await productRef.update({'productId': productId});

      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully')),
      );

      setState(() {
        _image = null;
        _formKey.currentState!.reset();
        _productNameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _selectedCategoryId = null;
        _selectedVendorId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _image != null
                        ? Image.memory(
                      _image,
                      fit: BoxFit.cover,
                    )
                        : Center(child: Text('Tap to select image')),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _productNameController,
                          decoration: InputDecoration(labelText: 'Product Name'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Product Price'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product price';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(labelText: 'Product Description'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            final categories = snapshot.data!.docs;
                            List<String> categoryNames = categories.map((doc) => doc['categoryName']).cast<String>().toList();
                            List<String> categoryIds = categories.map((doc) => doc.id).cast<String>().toList(); // Get categoryIds
                            return DropdownButtonFormField<String>(
                              value: _selectedCategoryId,
                              items: categoryNames.map((categoryName) {
                                return DropdownMenuItem<String>(
                                  value: categoryIds[categoryNames.indexOf(categoryName)], // Use categoryId as value
                                  child: Text(categoryName),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategoryId = value;
                                });
                              },
                              decoration: InputDecoration(labelText: 'Product Category'),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select product category';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('vendors').where('categoryId', isEqualTo: _selectedCategoryId).snapshots(),
                          builder: (context, snapshot) {
                            if (_selectedCategoryId == null) return SizedBox(); // Return empty SizedBox if category is not selected
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            final vendors = snapshot.data!.docs;
                            List<String> vendorNames = vendors.map((doc) => doc['businessName']).cast<String>().toList();
                            List<String> vendorIds = vendors.map((doc) => doc.id).cast<String>().toList(); // Get vendorIds
                            return DropdownButtonFormField<String>(
                              value: _selectedVendorId,
                              items: vendorNames.map((vendorName) {
                                return DropdownMenuItem<String>(
                                  value: vendorIds[vendorNames.indexOf(vendorName)], // Use vendorId as value
                                  child: Text(vendorName),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedVendorId = value;
                                });
                              },
                              decoration: InputDecoration(labelText: 'Select Vendor'),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a vendor';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _uploadProduct,
                child: Text('Save'),
              ),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.grey,),
            SizedBox(height: 20),
            ProductWidget(),
          ],
        ),
      ),
    );
  }
}

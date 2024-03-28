// import 'package:flutter/material.dart';
//
// class VendorsScreen extends StatelessWidget {
//   static const String routeName = '\VendorsScreen';
//
//   Widget _rowHeader(String text, int flex) {
//     return Expanded(
//         child: Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade700),
//         color: Colors.yellow.shade900,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(text , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
//       ),
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Container(
//             alignment: Alignment.topLeft,
//             padding: const EdgeInsets.all(10),
//             child: const Text(
//               'Manage Vendors',
//               style: TextStyle(
//                 fontWeight: FontWeight.w700,
//                 fontSize: 36,
//               ),
//             ),
//           ),
//           Row(children: [
//             _rowHeader('LOGO', 1),
//             _rowHeader('BUSSINESS NAME', 3),
//             _rowHeader('CITY', 2),
//             _rowHeader('STATE', 2),
//             _rowHeader('ACTION', 1),
//             _rowHeader('VIEW MORE', 1),
//           ],)
//         ],
//       ),
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// // import 'package:shopworm_web_admin/views/screens/side_bar_screen/widgets/vendor_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:shopworm_web_admin/views/screens/side_bar_screen/widgets/vendor_widget.dart';
//
// class VendorsScreen extends StatefulWidget {
//   static const String routeName = '\VendorsScreen';
//
//   @override
//   State<VendorsScreen> createState() => _VendorsScreenState();
// }
//
// class _VendorsScreenState extends State<VendorsScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//
//   dynamic _image;
//   String? _selectedCategory;
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   TextEditingController _businessNameController = TextEditingController();
//   TextEditingController _cityController = TextEditingController();
//   TextEditingController _stateController = TextEditingController();
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
//   Future<String> _uploadvendorToStorage(dynamic image, String fileName) async {
//     Reference ref = _storage.ref().child('vendorImages').child(fileName);
//
//     UploadTask uploadTask = ref.putData(image);
//
//     await uploadTask.whenComplete(() => print('vendor image uploaded'));
//
//     String downloadUrl = await ref.getDownloadURL();
//     return downloadUrl;
//   }
//
//   Future<void> _uploadvendor() async {
//     if (_formKey.currentState!.validate()) {
//       // Validate form fields
//       EasyLoading.show(status: 'Uploading vendor...');
//       String imageUrl = await _uploadvendorToStorage(_image, _businessNameController.text);
//
//       // Get the count of existing vendors to generate a unique vendor ID
//       int vendorId = await _firestore.collection("vendors").get().then((value) => value.docs.length + 1);
//
//       // Upload vendor details to Firestore
//       await _firestore.collection("vendors").doc(vendorId.toString()).set({
//         'image': imageUrl,
//         'businessName': _businessNameController.text,
//         'vendorId': vendorId,
//         'vendorCity': _cityController.text,
//         'vendorState': _stateController.text,
//         'categoryName': _selectedCategory,
//       });
//
//       EasyLoading.dismiss();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('vendor added successfully')),
//       );
//
//       setState(() {
//         _image = null;
//         _formKey.currentState!.reset();
//         _businessNameController.clear();
//         _cityController.clear();
//         _stateController.clear();
//         _selectedCategory = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add vendor'),
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
//                           controller: _businessNameController,
//                           decoration: InputDecoration(labelText: 'Business Name'),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter business name';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 10),
//                         TextFormField(
//                           controller: _cityController,
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(labelText: 'Vendor City'),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter vendor city';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 10),
//                         TextFormField(
//                           controller: _stateController,
//                           decoration: InputDecoration(labelText: 'Vendor State'),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter vendor state';
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
//                               decoration: InputDecoration(labelText: 'Vendor Category'),
//                               validator: (value) {
//                                 if (value == null) {
//                                   return 'Please select vendor category';
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
//                 onPressed: _uploadvendor,
//                 child: Text('Save'),
//               ),
//             ),
//             SizedBox(height: 20),
//             Divider(color: Colors.grey,),
//             SizedBox(height: 20),
//             VendorWidget(),
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
import 'package:shopworm_web_admin/views/screens/side_bar_screen/widgets/vendor_widget.dart';

class VendorsScreen extends StatefulWidget {
  static const String routeName = '/vendors_screen';

  @override
  State<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  dynamic _image;
  String? _selectedCategory;
  String? _selectedCategoryId; // New field to store categoryId

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _businessNameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();

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

  Future<String> _uploadVendorImageToStorage(dynamic image, String fileName) async {
    Reference ref = _storage.ref().child('vendorImages').child(fileName);

    UploadTask uploadTask = ref.putData(image);

    await uploadTask.whenComplete(() => print('Vendor image uploaded'));

    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _uploadVendor() async {
    if (_formKey.currentState!.validate()) {
      // Validate form fields
      EasyLoading.show(status: 'Uploading vendor...');
      String imageUrl = await _uploadVendorImageToStorage(_image, _businessNameController.text);

      // Generate a unique vendor ID
      String vendorId = _firestore.collection("vendors").doc().id;

      // Upload vendor details to Firestore
      await _firestore.collection("vendors").doc(vendorId).set({
        'vendorId': vendorId, // Store the generated vendor ID
        'image': imageUrl,
        'businessName': _businessNameController.text,
        'vendorCity': _cityController.text,
        'vendorState': _stateController.text,
        'categoryId': _selectedCategoryId,
      }).then((value) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vendor added successfully')),
        );

        setState(() {
          _image = null;
          _formKey.currentState!.reset();
          _businessNameController.clear();
          _cityController.clear();
          _stateController.clear();
          _selectedCategory = null;
          _selectedCategoryId = null;
        });
      }).catchError((error) {
        print('Error uploading vendor: $error');
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add vendor')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add vendor'),
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
                          controller: _businessNameController,
                          decoration: InputDecoration(labelText: 'Business Name'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter business name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _cityController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(labelText: 'Vendor City'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter vendor city';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _stateController,
                          decoration: InputDecoration(labelText: 'Vendor State'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter vendor state';
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
                            List<String> categoryNames =
                            categories.map((doc) => doc['categoryName']).cast<String>().toList();
                            List<String> categoryIds = // New list to store categoryIds
                            categories.map((doc) => doc.id).cast<String>().toList();
                            return DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              items: categoryNames.map((categoryName) {
                                int index = categoryNames.indexOf(categoryName);
                                return DropdownMenuItem<String>(
                                  value: categoryIds[index], // Use categoryId
                                  child: Text(categoryName),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                  _selectedCategoryId = value; // Store categoryId
                                });
                              },
                              decoration: InputDecoration(labelText: 'Vendor Category'),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select vendor category';
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
                onPressed: _uploadVendor,
                child: Text('Save'),
              ),
            ),
            SizedBox(height: 20),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            VendorWidget(),
          ],
        ),
      ),
    );
  }
}

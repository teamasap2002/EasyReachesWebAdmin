// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:shopworm_web_admin/views/screens/side_bar_screen/widgets/category_widget.dart';
//
// class CategoriesScreen extends StatefulWidget {
//   static const String routeName = '\CategoriesScreen';
//
//   @override
//   State<CategoriesScreen> createState() => _CategoriesScreenState();
// }
//
// class _CategoriesScreenState extends State<CategoriesScreen> {
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   dynamic _image;
//
//   String? fileName;
//   late String categoryName;
//
//   _pickImage() async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(allowMultiple: false, type: FileType.image);
//
//     if (result != null) {
//       setState(() {
//         _image = result?.files.first.bytes;
//         // fileName = result.files.first.name;
//       });
//     }
//   }
//
//   _uploadCategoryBannerToStorage(dynamic image) async {
//     Reference ref = _storage.ref().child('categoryImages').child(fileName!);
//
//     UploadTask uploadTask = ref.putData(image);
//
//     TaskSnapshot snapshot = await uploadTask;
//
//     String downloadUrl = await snapshot.ref.getDownloadURL();
//     return downloadUrl;
//   }
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   uploadCategory() async {
//     EasyLoading.show();
//     if (_formKey.currentState!.validate()) {
//       String imageUrl = await _uploadCategoryBannerToStorage(_image);
//       late int categoryId;
//
//       // Returns number of documents in users collection
//       await _firestore.collection("categories").count().get().then(
//             (res) {
//               print(res.count);
//               categoryId = (res.count! + 1);
//             },
//         onError: (e) => print("Error completing: $e"),
//       );
//
//       await _firestore.collection("categories").doc(fileName).set({
//         'image': imageUrl,
//         'categoryName': categoryName,
//         'categoryId' : categoryId,
//       }).whenComplete(() {
//         EasyLoading.dismiss();
//         setState(() {
//           _image = null;
//           _formKey.currentState!.reset();
//         });
//       });
//     } else {
//       print("in valid form fields");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             Container(
//               alignment: Alignment.topLeft,
//               padding: const EdgeInsets.all(10),
//               child: const Text(
//                 'Category',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 36,
//                 ),
//               ),
//             ),
//             Divider(
//               color: Colors.grey,
//             ),
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(14.0),
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 140,
//                         width: 140,
//                         decoration: BoxDecoration(
//                             color: Colors.grey.shade500,
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(color: Colors.black)),
//                         child: _image != null
//                             ? Image.memory(
//                                 _image,
//                                 fit: BoxFit.cover,
//                               )
//                             : Center(child: Text("Category Image")),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               primary: Colors.yellow.shade900),
//                           onPressed: () {
//                             _pickImage();
//                           },
//                           child: Text(
//                             "Upload Category",
//                             style: TextStyle(color: Colors.white),
//                           )),
//                     ],
//                   ),
//                 ),
//                 Flexible(
//                     child: SizedBox(
//                   width: 250,
//                   child: TextFormField(
//                     onChanged: (value) {
//                       categoryName = value;
//                       fileName = value;
//                     },
//                     validator: (vallue) {
//                       if (vallue!.isEmpty) {
//                         return "Category cannot be empty";
//                       } else {
//                         return null;
//                       }
//                     },
//                     decoration: InputDecoration(
//                         labelText: "Category Name",
//                         hintText: "Enter Category Name"),
//                   ),
//                 )),
//                 ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         primary: Colors.yellow.shade900),
//                     onPressed: () {
//                       uploadCategory();
//                     },
//                     child: Text(
//                       "Save",
//                       style: TextStyle(color: Colors.white),
//                     )),
//               ],
//             ),
//             Divider(
//               color: Colors.grey,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 alignment: Alignment.topLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     "Categories",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 36,),
//                   ),
//                 ),
//               ),
//             ),
//             CategoryWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shopworm_web_admin/views/screens/side_bar_screen/widgets/category_widget.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = '\CategoriesScreen';

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  dynamic _image;

  late String categoryName;

  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result != null) {
      setState(() {
        _image = result?.files.first.bytes;
      });
    }
  }

  _uploadCategoryBannerToStorage(dynamic image, String fileName) async {
    Reference ref = _storage.ref().child('categoryImages').child(fileName);

    UploadTask uploadTask = ref.putData(image);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  uploadCategory() async {
    EasyLoading.show();
    if (_formKey.currentState!.validate()) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String imageUrl = await _uploadCategoryBannerToStorage(_image, fileName);

      DocumentReference docRef =
      await _firestore.collection("categories").add({
        'image': imageUrl,
        'categoryName': categoryName,
      });

      // Store categoryId with field name as categoryId
      await docRef.update({'categoryId': docRef.id});

      EasyLoading.dismiss();
      setState(() {
        _image = null;
        _formKey.currentState!.reset();
      });
    } else {
      print("Invalid form fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Category',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black)),
                        child: _image != null
                            ? Image.memory(
                          _image,
                          fit: BoxFit.cover,
                        )
                            : Center(child: Text("Category Image")),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow.shade900),
                          onPressed: () {
                            _pickImage();
                          },
                          child: Text(
                            "Upload Category",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
                Flexible(
                    child: SizedBox(
                      width: 250,
                      child: TextFormField(
                        onChanged: (value) {
                          categoryName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Category cannot be empty";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Category Name",
                            hintText: "Enter Category Name"),
                      ),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade900),
                    onPressed: () {
                      uploadCategory();
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Categories",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                  ),
                ),
              ),
            ),
            CategoryWidget(),
          ],
        ),
      ),
    );
  }
}

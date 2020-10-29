import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:ohstel_food_market_app/hive_methods/hive_class.dart';
import 'package:ohstel_food_market_app/market_place/models/product_model.dart';
import 'package:uuid/uuid.dart';

import '../../constant.dart';
import '../market_methods.dart';

class AddNewMarketProductPage extends StatefulWidget {
  @override
  _AddNewMarketProductPageState createState() =>
      _AddNewMarketProductPageState();
}

class _AddNewMarketProductPageState extends State<AddNewMarketProductPage> {
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  StreamController _uniNameController = StreamController.broadcast();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopEmailController = TextEditingController();
  TextEditingController shopPhoneNumberController = TextEditingController();
  String productShopName;
  String productName;
  int productPrice;
  int productShopOwnerPhoneNumber;
  String productShopOwnerEmail;
  String productDescription;
  String productOriginLocation;
  String productCategory;
  String productSubCategory;
  List<File> imagesFiles = List<File>();

  String uniName;
  List<String> subCategory;
  bool isSending = false;
  bool loading = true;
  bool showSize = false;
  List sizeList = [];

  Future getUniList() async {
    String url = baseApiUrl +"/hostel_api/searchKeys";
    var response = await http.get(url);
    var result = json.decode(response.body);
    print(result);
    return result;
  }

  void _showEditUniDailog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Uni'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: FutureBuilder(
              future: getUniList(),
              builder: (context, snapshot) {
                print(snapshot.data);
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                print(snapshot.data);
                Map data = snapshot.data;
                return Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      List<String> uniList = data.keys.toList();
                      uniList.sort();
                      Map currentUniDetails = data[uniList[index]];

                      return Column(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: ListTile(
                                onTap: () {
                                  _uniNameController
                                      .add(currentUniDetails['abbr']);
                                  Navigator.pop(context);
                                },
                                title: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${currentUniDetails['name']}',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  '${currentUniDetails['abbr']}',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey,
                                  ),
                                ),
                              )),
                          Divider(),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    try {
      if (pickedFile != null) {
        imagesFiles.add(File(pickedFile.path));
//        _foodImage = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
        print('No image selected.');
      }
    } on Exception catch (e, s) {
      print(e);
      print(s);
      Fluttertoast.showToast(msg: 'Error: $e');
    }

    if (!mounted) return;
    setState(() {});
  }

  Future getUrls() async {
    List<String> imageUrl = [];

//    print(images);
    for (var imageFile in imagesFiles) {
      String url = await postImage(imageFile);
      print(url);
      imageUrl.add(url.toString());
      print(imageUrl);
    }

    if (imageUrl.length == imagesFiles.length) {
      print('got here');

      ProductModel productModel = ProductModel(
        productName: productName,
        imageUrls: imageUrl,
        productCategory: productCategory,
        productOriginLocation: productOriginLocation,
        productDescription: productDescription,
        productSubCategory: productSubCategory,
        productPrice: productPrice,
        productShopName: productShopName,
        productShopOwnerEmail: productShopOwnerEmail,
        productShopOwnerPhoneNumber: productShopOwnerPhoneNumber,
        sizeInfo: sizeList ?? null,
      );
      print(productModel.toMap());
      await MarketMethods().saveProductToServer(productModel: productModel);
    }
  }

  Future<dynamic> postImage(File imageFile) async {
    try {
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child('marketImage/${Uuid().v1()}');

      StorageUploadTask uploadTask = storageReference.putFile(imageFile);

      await uploadTask.onComplete;
      print('File Uploaded');

      String url = await storageReference.getDownloadURL();

      return url;
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: err);
    }
  }

  Future<void> saveData() async {
    if (formKey.currentState.validate() &&
        productOriginLocation != null &&
        imagesFiles.isNotEmpty &&
        productCategory != null &&
        productSubCategory != null) {
      formKey.currentState.save();
      print('pass');
      setState(() {
        isSending = true;
      });
      print('one');
//      await Future.delayed(Duration(seconds: 10));
      await getUrls();
      print('two');
      setState(() {
        isSending = false;
        formKey.currentState.reset();
        imagesFiles = List<File>();
        productOriginLocation = null;
      });
      Fluttertoast.showToast(msg: 'Upload Done!!');
    } else {
      Fluttertoast.showToast(msg: 'Fill All Details');
    }
  }

  Future<void> getData() async {
    setState(() {
      loading = true;
    });
    Map data = await HiveMethods().getUserData();
    shopNameController.text = data['shopName'];
    shopEmailController.text = data['email'];
    shopPhoneNumberController.text = data['phoneNumber'];
    print(data);
    setState(() {
      loading = false;
    });
  }

  Future<void> showSizePoPup() async {
    String _size;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Enter Size'),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'Enter Size',
            ),
            onChanged: (val) {
              _size = val;
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Save'),
              onPressed: () {
                sizeList.add(_size);
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uplaod Hostel'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                form(),
              ],
            ),
    );
  }

  Widget form() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: TextFormField(
              controller: shopNameController,
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Product Shop Name Can\'t Be Empty';
                } else if (value.trim().length < 3) {
                  return 'Product Shop Name Must Be More Than 2 Characters';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: 'Product Shop Name',
              ),
              onSaved: (value) => productShopName = value.trim(),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15),
          ),
          Container(
            child: TextFormField(
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Product Name Can\'t Be Empty';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: 'Product Name',
              ),
              onSaved: (value) => productName = value.trim(),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15),
          ),
          Container(
            child: TextFormField(
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Product Price Can\'t Be Empty';
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Product Price',
              ),
              onSaved: (value) => productPrice = int.parse(value.trim()),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    child: TextFormField(
                      controller: shopEmailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Shop Owner Email Can\'t Be Empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Shop Owner Email',
                      ),
                      onSaved: (value) => productShopOwnerEmail = value.trim(),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: TextFormField(
                      controller: shopPhoneNumberController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Shop Owner Phone Number Can\'t Be Empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Shop Owner Phone Number',
                      ),
                      onSaved: (value) =>
                          productShopOwnerPhoneNumber = int.parse(value.trim()),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: TextFormField(
//                      keyboardType: TextInputType.number,
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'product Description Can\'t Be Empty';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: 'product Description',
              ),
              onSaved: (value) => productDescription = value.trim(),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatButton(
                  color: Colors.green,
                  onPressed: () {
                    _showEditUniDailog();
                  },
                  child: Text('Select Location'),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: StreamBuilder(
                    stream: _uniNameController.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('No Loacation Selected');
                      } else {
                        uniName = snapshot.data;
                        productOriginLocation = snapshot.data;
                        return Text('${snapshot.data}');
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          DropdownButton(
            // select Category
            hint: Text("Select Category"),
            value: productCategory,
            onChanged: (value) {
              setState(() {
                subCategory = null;
                productCategory = null;
                productSubCategory = null;

                subCategory = categoryMap['$value'];
                print(categoryMap['$value']);

                productCategory = value;
              });
            },
            items: categoryMap.keys.map((element) {
              return DropdownMenuItem(
                value: element,
                child: Text(
                  element,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          subCategory != null
              ? DropdownButton(
                  // select  sub Category
                  hint: Text("Select Sub Category"),
                  value: productSubCategory,
                  onChanged: (value) {
                    setState(() {
                      productSubCategory = value;
                    });
                  },
                  items: subCategory.map((element) {
                    return DropdownMenuItem(
                      value: element,
                      child: Text(
                        element,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                )
              : Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text('Select A Category First!!'),
                ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Show Size'),
              Switch(
                value: showSize,
                onChanged: (value) {
                  setState(() {
                    showSize = value;
                    print(showSize);
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ],
          ),
          SizedBox(height: 20),
          showSize ? showSizeWidget() : Container(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Add Image',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                child: (imagesFiles != null && imagesFiles.isNotEmpty)
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            imagesFiles = List<File>();
                          });
                        },
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.black,
                        ),
                      )
                    : Container(),
              )
            ],
          ),
          buildGridView(),
          SizedBox(height: 10),
          isSending
              ? Center(child: CircularProgressIndicator())
              : FlatButton(
                  color: Colors.green,
                  onPressed: () {
                    saveData();
                  },
                  child: Text('Save'),
                ),
        ],
      ),
    );
  }

  Widget showSizeWidget() {
    return Container(
      child: Column(
        children: [
          FlatButton(
            onPressed: () async {
              await showSizePoPup();
              setState(() {});
            },
            color: Colors.green,
            child: Text('ADD SIZE!'),
          ),
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: sizeList.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.transparent,
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text('${sizeList[index]}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridView() {
    return SizedBox(
      height: 150,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          eachImage(index: 0),
          eachImage(index: 1),
          eachImage(index: 2),
          eachImage(index: 4),
          eachImage(index: 5),
        ],
      ),
    );
  }

  Widget eachImage({@required int index}) {
    try {
      File asset = imagesFiles[index];
      return Container(
        margin: EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.file(
            asset,
            height: 100,
            width: 100,
            fit: BoxFit.fill,
          ),
        ),
      );
    } on RangeError catch (_) {
      return Container(
        margin: EdgeInsets.all(10.0),
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey,
        ),
        child: IconButton(
          onPressed: () {
            getImage();
          },
          icon: Icon(
            Icons.add_photo_alternate,
            color: Colors.white,
            size: 50,
          ),
        ),
      );
    }
  }
}

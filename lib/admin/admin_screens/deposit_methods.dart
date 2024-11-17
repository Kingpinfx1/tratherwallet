// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:firstwallet/admin/admin_screens/edit_payments.dart';
import 'package:firstwallet/api_connection/api_connection.dart';
import 'package:firstwallet/users/model/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class DepositMethods extends StatefulWidget {
  const DepositMethods({super.key});

  @override
  State<DepositMethods> createState() => _DepositMethodsState();
}

class _DepositMethodsState extends State<DepositMethods> {
  final ImagePicker _picker = ImagePicker();

  XFile? pickedImageXFile;

  var formKey = GlobalKey<FormState>();
  var walletNameController = TextEditingController();
  var walletDescriptionController = TextEditingController();
  var imageLink = "";

  Future<String> deletePaymentMethod(PaymentMethods paymentmethod) async {
    try {
      var res = await http.post(Uri.parse(API.deletePaymentMethod), body: {
        'id': paymentmethod.id.toString(),
      });

      if (res.statusCode == 200) {
        var resBodyOfUpdate = jsonDecode(res.body);

        if (resBodyOfUpdate['success'] == true) {
          Fluttertoast.showToast(
            msg: "Deleted",
            gravity: ToastGravity.CENTER,
          );
          return "Deleted";
        } else {
          Fluttertoast.showToast(msg: "Failed to delete  ");
          return "Failed to update user ";
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
        return "Failed to connect to server";
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error: $error");
      return "An error occurred: $error";
    }
  }

  Future<List<PaymentMethods>> getAllPaymentMethods() async {
    List<PaymentMethods> allPaymentMethods = [];

    try {
      var res = await http.post(Uri.parse(API.readAllWallets));

      if (res.statusCode == 200) {
        var resBodyOfPaymentMethods = jsonDecode(res.body);

        if (resBodyOfPaymentMethods['success'] == true) {
          for (var eachPaymentMethod
              in (resBodyOfPaymentMethods['paymentMethods'] as List)) {
            allPaymentMethods.add(PaymentMethods.fromJson(eachPaymentMethod));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:: $errorMsg");
    }

    return allPaymentMethods;
  }

  captureImageWithPhoneCamera() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);

    Get.back();

    setState(() => pickedImageXFile);
  }

  pickImageFromPhoneGallery() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);

    Get.back();

    setState(() => pickedImageXFile);
  }

  showDialogBoxForImagePickingAndCapturing() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.black45,
            title: const Text(
              "Upload Wallet Qr",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  captureImageWithPhoneCamera();
                },
                child: const Text(
                  "Capture with Phone Camera",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickImageFromPhoneGallery();
                },
                child: const Text(
                  "Pick Image From Phone Gallery",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget defaultScreen() {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text('Add Payment Methods'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 100,
              color: Colors.deepPurple,
            ),
            ElevatedButton(
              onPressed: () {
                showDialogBoxForImagePickingAndCapturing();
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                Colors.deepPurple,
              )),
              child: Text(
                'Upload Qr code',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(child: allPaymentMethods()),
          ],
        ),
      ),
    );
  }

  uploadItemImage() async {
    var requestImgurApi = http.MultipartRequest(
        "POST", Uri.parse("https://api.imgur.com/3/image"));

    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    requestImgurApi.fields['title'] = imageName;
    requestImgurApi.headers['Authorization'] = "Client-ID " "d4e9590ffe68b02";

    var imageFile = await http.MultipartFile.fromPath(
      'image',
      pickedImageXFile!.path,
      filename: imageName,
    );

    requestImgurApi.files.add(imageFile);
    var responseFromImgurApi = await requestImgurApi.send();

    var responseDataFromImgurApi = await responseFromImgurApi.stream.toBytes();
    var resultFromImgurApi = String.fromCharCodes(responseDataFromImgurApi);

    Map<String, dynamic> jsonRes = json.decode(resultFromImgurApi);
    (jsonRes["data"]["deletehash"]).toString();
    // String deleteHash =
    saveItemInfoToDatabase();
  }

  saveItemInfoToDatabase() async {
    try {
      var response = await http.post(
        Uri.parse(API.adminUploadWallet),
        body: {
          'id': '1',
          'name': walletNameController.text.trim().toString(),
          'description': walletDescriptionController.text.trim().toString(),
          'image': imageLink.toString(),
        },
      );

      if (response.statusCode == 200) {
        var resBodyOfUploadItem = jsonDecode(response.body);

        if (resBodyOfUploadItem['success'] == true) {
          Fluttertoast.showToast(msg: "New wallet uploaded successfully");

          setState(() {
            pickedImageXFile = null;
            walletNameController.clear();
            walletDescriptionController.clear();
          });

          Get.to(() => DepositMethods());
        } else {
          Fluttertoast.showToast(msg: "wallet not uploaded. Error, Try Again.");
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error: $errorMsg");
      return "An error occurred: $errorMsg";
    }
  }

  Widget uploadWalletDetails() {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white,
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          "Upload wallet details",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            setState(() {
              pickedImageXFile = null;
              walletNameController.clear();
              walletDescriptionController.clear();
            });

            Get.to(() => DepositMethods());
          },
          icon: const Icon(
            Icons.clear,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Fluttertoast.showToast(msg: "Uploading now...");

              uploadItemImage();
            },
            child: const Text(
              "Done",
              style: TextStyle(
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          //image
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(pickedImageXFile!.path),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //upload item form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
              child: Column(
                children: [
                  //email-password-login button
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        //wallet name
                        TextFormField(
                          controller: walletNameController,
                          validator: (val) =>
                              val == "" ? "Please write wallet name" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.title,
                              color: Colors.deepPurple,
                            ),
                            hintText: "Wallet name...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.white60,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.white60,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.white60,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.white60,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),

                        const SizedBox(height: 18),

                        //wallet description
                        TextFormField(
                          controller: walletDescriptionController,
                          validator: (val) => val == ""
                              ? "Please write wallet description"
                              : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.rate_review,
                              color: Colors.deepPurple,
                            ),
                            hintText: "Wallet address...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.white60,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.white60,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.white60,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.white60,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),

                        const SizedBox(height: 18),

                        //button
                        Material(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(30),
                          child: InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                Fluttertoast.showToast(msg: "Uploading now...");

                                uploadItemImage();
                              }
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 28,
                              ),
                              child: Text(
                                "Upload Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget allPaymentMethods() {
    return ListView(
      children: [
        FutureBuilder(
          future: getAllPaymentMethods(),
          builder: (context, AsyncSnapshot<List<PaymentMethods>> dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (dataSnapShot.data == null) {
              return const Center(
                child: Text(
                  "No Payment Method found",
                ),
              );
            }
            if (dataSnapShot.data!.isNotEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 150),
                  itemCount: dataSnapShot.data!.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    //instance of items from model

                    PaymentMethods eachPaymentMethod =
                        dataSnapShot.data![index];

                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(
                        index == 0 ? 16 : 8,
                        2,
                        index == dataSnapShot.data!.length - 1 ? 16 : 8,
                        2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade100,
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 3,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // ID and Email/name column
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      eachPaymentMethod.id.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          eachPaymentMethod.name.toString(),
                                          style: const TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          eachPaymentMethod.description
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // Delete and edit row
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        deletePaymentMethod(eachPaymentMethod);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red.shade300,
                                      ),
                                    ),
                                    // const SizedBox(width: 2),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditPaymentScreen(
                                              eachPaymentMethod:
                                                  eachPaymentMethod,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.black38,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text("Empty, No Data."),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return pickedImageXFile == null ? defaultScreen() : uploadWalletDetails();
  }
}

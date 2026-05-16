// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:tratherwallet/admin/admin_preferences.dart';
import 'package:tratherwallet/admin/admin_screens/edit_payments.dart';
import 'package:tratherwallet/api_connection/api_connection.dart';
import 'package:tratherwallet/users/model/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class DepositMethods extends StatefulWidget {
  const DepositMethods({super.key});

  @override
  State<DepositMethods> createState() => _DepositMethodsState();
}

class _DepositMethodsState extends State<DepositMethods> {
  static const Color bg = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color teal = Color(0xFF0F766E);
  static const Color border = Color(0xFF334155);

  final ImagePicker _picker = ImagePicker();

  XFile? pickedImageXFile;

  var formKey = GlobalKey<FormState>();
  var walletNameController = TextEditingController();
  var walletDescriptionController = TextEditingController();
  var imageLink = "";

  Future<String> deletePaymentMethod(PaymentMethods paymentmethod) async {
    final token = await AdminPrefs.getAdminToken();
    try {
      var res = await http.post(Uri.parse(API.deletePaymentMethod), body: {
        'id': paymentmethod.id.toString(),
        'admin_token': token,
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
          Fluttertoast.showToast(msg: "Failed to delete");
          return "Failed to delete";
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
          backgroundColor: surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "Upload Wallet QR",
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () => captureImageWithPhoneCamera(),
              child: Text(
                "Capture with Camera",
                style: GoogleFonts.spaceGrotesk(color: Colors.white70),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => pickImageFromPhoneGallery(),
              child: Text(
                "Pick from Gallery",
                style: GoogleFonts.spaceGrotesk(color: Colors.white70),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Get.back(),
              child: Text(
                "Cancel",
                style: GoogleFonts.spaceGrotesk(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget defaultScreen() {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Deposit Methods',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(Icons.add_photo_alternate, size: 64, color: teal),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: showDialogBoxForImagePickingAndCapturing,
                    icon: const Icon(Icons.upload),
                    label: Text(
                      'Upload QR Code',
                      style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: allPaymentMethods()),
        ],
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
    imageLink = jsonRes["data"]["link"].toString();
    saveItemInfoToDatabase();
  }

  saveItemInfoToDatabase() async {
    final token = await AdminPrefs.getAdminToken();
    try {
      var response = await http.post(
        Uri.parse(API.adminUploadWallet),
        body: {
          'id': '1',
          'name': walletNameController.text.trim().toString(),
          'description': walletDescriptionController.text.trim().toString(),
          'image': imageLink.toString(),
          'admin_token': token,
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
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        title: Text(
          "Upload Wallet Details",
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
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
          icon: const Icon(Icons.clear, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Fluttertoast.showToast(msg: "Uploading now...");
              uploadItemImage();
            },
            child: Text(
              "Done",
              style: GoogleFonts.spaceGrotesk(
                color: teal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(pickedImageXFile!.path)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: border),
                    ),
                    child: TextFormField(
                      controller: walletNameController,
                      validator: (val) =>
                          val == "" ? "Please write wallet name" : null,
                      style: GoogleFonts.spaceGrotesk(
                          color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        prefixIcon: const Icon(Icons.title,
                            color: Color(0xFF0F766E), size: 20),
                        hintText: 'Wallet name...',
                        hintStyle: GoogleFonts.spaceGrotesk(
                            color: Colors.white38, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: border),
                    ),
                    child: TextFormField(
                      controller: walletDescriptionController,
                      validator: (val) =>
                          val == "" ? "Please write wallet address" : null,
                      style: GoogleFonts.spaceGrotesk(
                          color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        prefixIcon: const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Color(0xFF0F766E),
                            size: 20),
                        hintText: 'Wallet address...',
                        hintStyle: GoogleFonts.spaceGrotesk(
                            color: Colors.white38, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Fluttertoast.showToast(msg: "Uploading now...");
                          uploadItemImage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Upload Now',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
    return FutureBuilder(
      future: getAllPaymentMethods(),
      builder: (context, AsyncSnapshot<List<PaymentMethods>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0F766E)),
          );
        }
        if (dataSnapShot.data == null || dataSnapShot.data!.isEmpty) {
          return Center(
            child: Text(
              "No deposit methods found.",
              style: GoogleFonts.spaceGrotesk(color: Colors.white60),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
          itemCount: dataSnapShot.data!.length,
          itemBuilder: (context, index) {
            PaymentMethods eachPaymentMethod = dataSnapShot.data![index];

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eachPaymentMethod.name.toString(),
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          eachPaymentMethod.description.toString(),
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            deletePaymentMethod(eachPaymentMethod),
                        icon: Icon(Icons.delete,
                            color: Colors.red.shade400, size: 20),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPaymentScreen(
                                eachPaymentMethod: eachPaymentMethod,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit,
                            color: Color(0xFF0F766E), size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return pickedImageXFile == null ? defaultScreen() : uploadWalletDetails();
  }
}

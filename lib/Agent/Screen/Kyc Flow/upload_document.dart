import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ceyron_app/Agent/Screen/Kyc%20Flow/selfie_document.dart';
import 'package:ceyron_app/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../Api/Controller/auth_provider.dart';
import '../../../Api/Controller/kyc_provider.dart';
import '../../../Api/Controller/local_stuff.dart';
import '../../../utils/next_screen.dart';

class UploadDoc extends StatefulWidget {
  Color color;
  String title;
  String image;
  UploadDoc({super.key,required this.color,required this.title,required this.image});

  @override
  State<UploadDoc> createState() => _UploadDocState();
}

class _UploadDocState extends State<UploadDoc> {
  // Color mainColor = Color(0xff183159);
  Color? mainColor;
  String selectedImageFront ='';
  String selectedImageBack = '';
  @override
  void initState() {
    super.initState();
     mainColor = widget.color;
  }
  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
        child: Column(children: [
          SizedBox(height: 30,),
          Row(children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
          ],),
          Image.asset(widget.image,scale: 1.7,),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${widget.title} ${lang?.translate('Verification')}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Colors.black),),
            ],
          ),
          SizedBox(height: 10,),
          Text("${lang?.translate('Please submit a valid government issued')} ${widget.title}",textAlign: TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.grey),),
          Spacer(),
          InkWell(
            onTap: (){
              _showAlert(context,true);
            },
            child: Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                border: Border.all(width: 1,color: mainColor!)
                // gradient: LinearGradient(colors: [
                //   primary,
                //   primary2,
                // ]),

              ),
              child: Row(
                children: [
                  Text("${lang?.translate('Upload')} ${widget.title} (${lang?.translate('Front View')})",style: TextStyle(color:mainColor,fontSize: 15,fontWeight: FontWeight.w500),),
                  Spacer(),
                  selectedImageFront.isNotEmpty?Icon(Icons.check_circle_rounded,color:  mainColor,):Image.asset('assets/icon/ic_upload.png',scale: 16,color: mainColor,),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: (){
              _showAlert(context,false);
            },
            child: Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(width: 1,color: mainColor!)
              ),
              child: Row(
                children: [
                  Text("${lang?.translate('Upload')} ${widget.title} (${lang?.translate('Back View')})",style: TextStyle(color:mainColor,fontSize: 15,fontWeight: FontWeight.w500),),
                  Spacer(),
                  selectedImageBack.isNotEmpty?Icon(Icons.check_circle_rounded,color:  mainColor,):Image.asset('assets/icon/ic_upload.png',scale: 16,color: mainColor,),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          InkWell(
            onTap: () async {
              if (selectedImageFront!.isNotEmpty) {
                if (selectedImageBack.isNotEmpty) {
                  final KP = context.read<KycProvider>();
                  final Au = context.read<AuthProvider>();

                  File frontImageFile = File(selectedImageFront);
                  File backImageFile = File(selectedImageBack);

                 final frontImageBytes = await FlutterImageCompress.compressWithFile(
                    frontImageFile.path,
                    quality: 50,
                  );
                  if (frontImageBytes != null) {
                    File compressedFrontImage = File(
                      (await getTemporaryDirectory()).path +
                          '/compressed_front_image.jpg',
                    );
                    await compressedFrontImage.writeAsBytes(frontImageBytes);
                    KP.KYC_Front_Image = compressedFrontImage;
                  }

                  // Compress back image
                  final backImageBytes = await FlutterImageCompress.compressWithFile(
                    backImageFile.path,
                    quality: 50, // Adjust the quality (0-100) as needed
                  );
                  if (backImageBytes != null) {
                    File compressedBackImage = File(
                      (await getTemporaryDirectory()).path +
                          '/compressed_back_image.jpg',
                    );
                    await compressedBackImage.writeAsBytes(backImageBytes);
                    KP.KYC_Back_Image = compressedBackImage;
                  }

                  try {
                    nextScreen(context, SelfieDocument());
                  } catch (e) {
                    print("Error: $e");
                  }
                } else {
                  showSnackbarError(context, "${lang?.translate('Please Upload Back Image')}");
                }
              } else {
                showSnackbarError(context, "${lang?.translate('Please Upload Front Image')}");
              }
            },


            child: Container(
              height: 55,
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  color: mainColor
                // gradient: LinearGradient(colors: [
                //   primary,
                //   primary2,
                // ])
              ),
              child: Text("${lang?.translate('Submit')}",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),),
            ),
          ),
          SizedBox(height: 20,),
        ],),
      ),
    );
  }
  late Map<String, dynamic> imageData;
  final ImagePicker _imagePicker = ImagePicker();


  Future<void> pickImageFront(bool camera) async {
     final pickedImage = await _imagePicker.pickImage(source: camera?ImageSource.camera:ImageSource.gallery);

    if (pickedImage != null) {
      setState(()  {
        selectedImageFront = pickedImage.path;
        final File pickedFile = File(pickedImage.path);
        final Uint8List bytes = pickedFile.readAsBytesSync();

      });
      Navigator.pop(context);
    }
  }
  Future<void> pickImageBack(bool camera) async {
    final pickedImage = await _imagePicker.pickImage(source: camera?ImageSource.camera:ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImageBack = pickedImage.path;
        final File pickedFile = File(pickedImage.path);
        final Uint8List bytes = pickedFile.readAsBytesSync();
        print("fieldname ======${selectedImageBack}");
      });
      Navigator.pop(context);
    }
  }

  void _showAlert(BuildContext context,bool front) {
    var lang = LocalizationStuff.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Select',
              style: TextStyle(
                color: mainColor,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: (){
                  front?pickImageFront(true):pickImageBack(true);
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(width: 1,color: mainColor!)
                    // gradient: LinearGradient(colors: [
                    //   primary,
                    //   primary2,
                    // ]),

                  ),
                  child: Row(
                    children: [
                      Text("${lang?.translate('Camera')}",style: TextStyle(color:mainColor,fontSize: 17,fontWeight: FontWeight.w500),),
                      Spacer(),
                      Icon(Icons.camera_alt,color: mainColor,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  front?pickImageFront(false):pickImageBack(false);
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(width: 1,color: mainColor!)
                    // gradient: LinearGradient(colors: [
                    //   primary,
                    //   primary2,
                    // ]),

                  ),
                  child: Row(
                    children: [
                      Text("${lang?.translate('Gallery')} ",style: TextStyle(color:mainColor,fontSize: 17,fontWeight: FontWeight.w500),),
                      Spacer(),
                      Icon(Icons.photo,color: mainColor,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,)
            ],
          ),

        );
      },
    );
  }

}

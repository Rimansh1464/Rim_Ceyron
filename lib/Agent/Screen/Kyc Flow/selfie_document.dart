import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../Api/Controller/auth_provider.dart';
import '../../../Api/Controller/kyc_provider.dart';
import '../../../Api/Controller/local_stuff.dart';
import '../../../utils/next_screen.dart';
import '../../../utils/widgets.dart';
import '../bottom_bar.dart';

class SelfieDocument extends StatefulWidget {
  const SelfieDocument({super.key});

  @override
  State<SelfieDocument> createState() => _SelfieDocumentState();
}

class _SelfieDocumentState extends State<SelfieDocument> {
  Color? mainColor;
  String selectedImageFront ='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainColor = Color(0xff9581c6);

  }
  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left:10, right:10, top:10),
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
          Image.asset('assets/image/selfie_doc.png',scale: 1.7,),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${lang?.translate('Take your selfie  with document photo')}",textAlign: TextAlign.center,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Colors.black),),
            ],
          ),
          SizedBox(height: 10,),
           Text("${lang?.translate('Please your face into the marked area and take a clear photo')}",textAlign: TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.grey),),
          Spacer(),
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
                  Text("${lang?.translate('Upload Photo')}",style: TextStyle(color:mainColor,fontSize: 15,fontWeight: FontWeight.w500),),
                  Spacer(),
                   selectedImageFront.isNotEmpty?Icon(Icons.check_circle_rounded,color:  mainColor,):Image.asset('assets/icon/ic_upload.png',scale: 16,color: mainColor,),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          InkWell(
            onTap: () async {
              if (selectedImageFront!.isNotEmpty) {
                final KP = context.read<KycProvider>();
                final Au = context.read<AuthProvider>();

                File imageFile = File(selectedImageFront);

                final frontImageBytes = await FlutterImageCompress.compressWithFile(
                  imageFile.path,
                  quality: 50,
                );
                if (frontImageBytes != null) {
                  File compressedFrontImage = File(
                    (await getTemporaryDirectory()).path +
                        '/compressed_selfie_image.jpg',
                  );
                  await compressedFrontImage.writeAsBytes(frontImageBytes);
                  KP.Selfie_with_document = compressedFrontImage;
                }
                // Check image size before proceeding
                int maxSizeBytes = 1024 * 1024; // 1MB
                // if (imageFile.lengthSync() > maxSizeBytes) {
                //   showSnackbarError(context, "Image size exceeds 1MB limit");
                //   selectedImageFront = "";
                //   setState(() {});
                //   return;
                // }


                KP.kycDetails(context);
              } else {
                showSnackbarError(context, "${lang?.translate('Please Upload Image')}");
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
    final pickedImage = await _imagePicker.pickImage(
        preferredCameraDevice: CameraDevice.front,
        source: camera?ImageSource.camera:ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {

        selectedImageFront = pickedImage.path;
        final File pickedFile = File(pickedImage.path);

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
              '${lang?.translate('Select')}',
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
                pickImageFront(true);
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
                  pickImageFront(false);
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

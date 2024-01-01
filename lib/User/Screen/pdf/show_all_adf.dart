import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Agent/AppBar/appbar.dart';
import '../../../Api/Controller/auth_provider.dart';
import '../../../Api/Controller/local_stuff.dart';
import '../../../utils/colors.dart';

class ShowAllPDF extends StatefulWidget {
  const ShowAllPDF({super.key});

  @override
  State<ShowAllPDF> createState() => _ShowAllPDFState();
}

class _ShowAllPDFState extends State<ShowAllPDF> {
  List<PDFFileInfo> pdfFiles = [];

  @override
  void initState() {
    super.initState();
    _loadPDFFiles();
  }

  Future<void> _loadPDFFiles() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);
    final customPDFDirectory = Directory('${(await getExternalStorageDirectory())?.path}/Download');
    if (customPDFDirectory.existsSync()) {
      pdfFiles = customPDFDirectory
          .listSync()
          .where((file) {
        if (file is File && file.path.endsWith('.pdf')) {
          final fileName = file.uri.pathSegments.last;
          // Replace 'userId' with the actual user ID you want to filter by
          return fileName.contains(authProvider.userData!.usersId) || fileName.startsWith(authProvider.userData!.usersId);
        }
        return false;
      })
          .map((file) {
        final stat = file.statSync();
        final name = file.uri.pathSegments.last;
        final path = file.path;
        final size = (stat.size / 1024).toStringAsFixed(2) + ' KB';
        final date = DateFormat('yyyy-MM-dd HH:mm:ss').format(stat.modified);
        return PDFFileInfo(name, size, date,path);
      })
          .toList();
      pdfFiles = pdfFiles.reversed.toList();
    }
    setState(() {});
  }
  Future<void> _deletePDFFile(int index) async {
    if (index >= 0 && index < pdfFiles.length) {
      final fileInfo = pdfFiles[index];
      final file = File(fileInfo.path);
      await file.delete();
      pdfFiles.removeAt(index);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: "${lang?.translate("Statement")}"),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10,),
          if (pdfFiles.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: pdfFiles.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                        OpenFile.open(pdfFiles[index].path);
                      },
                    child: Container(

                      width:double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,boxShadow: [BoxShadow(color: Colors.grey.shade300,blurRadius: 10,)]),
                      child: Row(children: [
                         Image.asset('assets/icon/ic_pdf.png',scale: 13,),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text("${pdfFiles[index].name}"),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("${pdfFiles[index].date.split(" ")[0]}",style: TextStyle(fontSize: 13,color: Colors.grey),),
                                SizedBox(width: 40,),
                                Text("${pdfFiles[index].size}",style: TextStyle(fontSize: 13,color: Colors.grey),),
                              ],
                            ),

                          ],),
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                            onTap: (){
                              Share.shareFiles([pdfFiles[index].path], text: '');
                              //_deletePDFFile(index);
                            },
                            child: Icon(Icons.share)),
                        SizedBox(width: 10,),
                        InkWell(
                            onTap: (){
                              //Share.shareFiles([pdfFiles[index].path], text: '');
                              //_deletePDFFile(index);
                              showDialog(context: context, builder: (context) => AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Lottie.asset("assets/lottie/Delete.json",height: 150),
                                    SizedBox(height: 20,),
                                    Text("${lang?.translate("Are You Sure")} ?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                                    SizedBox(height: 10,),
                                    Text("${lang?.translate("Do you really want to delete these records? This process cannot be undone.")}",textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: Colors.grey),),
                                    SizedBox(height: 40,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12.0),
                                             color: Colors.grey.shade400,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF4C2E84)
                                                      .withOpacity(0.2),
                                                  offset: const Offset(0, 15.0),
                                                  blurRadius: 60.0,
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              '${lang?.translate("Cancel")}',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                height: 1.5,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _deletePDFFile(index);
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12.0),
                                              gradient: LinearGradient(
                                                colors: [
                                                  primary,
                                                  primary2,
                                                ],
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF4C2E84)
                                                      .withOpacity(0.2),
                                                  offset: const Offset(0, 15.0),
                                                  blurRadius: 60.0,
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              '${lang?.translate("Delete")}',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                height: 1.5,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],),
                              ));

                            },
                            child: Icon(Icons.delete,color: Colors.red,)),

                        SizedBox(width: 10,),
                      ],),
                    ),
                  );
                },
              ),
            ),
          if (pdfFiles.isEmpty)
            Center(
              child: Text("${lang?.translate("No Statement found...")}"),
            ),
        ],
      ),
    );
  }

}
class PDFFileInfo {
  final String name;
  final String size;
  final String date;
  final String path;

  PDFFileInfo(this.name, this.size, this.date,this.path);
}
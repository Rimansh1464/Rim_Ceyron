import 'package:ceyron_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Agent/AppBar/appbar.dart';
import '../Agent/splash/splash.dart';
import '../Api/Controller/getx_controller.dart';
import '../Api/Controller/local_stuff.dart';
import 'colors.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  bool first = false;
  GetController getController = Get.put(GetController());

  void changeLanguage(String langcode) async {
    Locale _locale = await getController.setLocale(langcode);
    getController.LanguageCode  = langcode;
    MyApp.setLocale(context, _locale);
  }
  int? isselected;
  checkIndex(){

    setState(() {
      if (getController.LanguageCode == "fr") {
        isselected = 1;
      }else if (getController.LanguageCode == "es") {
        isselected = 2;
      }else if (getController.LanguageCode == "it") {
        isselected = 3;
      }else if (getController.LanguageCode == "ar") {
        isselected = 4;
      }else if (getController.LanguageCode == "hi") {
        isselected = 5;
      }else if (getController.LanguageCode == "cn") {
        isselected = 6;
      }else if (getController.LanguageCode == "pt") {
        isselected = 7;
      } else if (getController.LanguageCode == "ru") {
        isselected = 8;
      } else if (getController.LanguageCode == "en") {
        isselected = 0;
      } else {
        isselected = 0;
      }
    });
    print("isselected ${isselected}");
  }

  @override
  void initState() {
    super.initState();
    checkIndex();
  }

  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: "${lang?.translate("Select Language")}"),
      body: Container(
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: getController.supportedLangList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            setState(() {
                              isselected = index;
                            });
                          },
                          child: Container(
                            height: 55,
                            margin: EdgeInsets.symmetric(vertical: 6),
                            padding: EdgeInsets.symmetric(horizontal: 7,vertical: 7),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.white,boxShadow: [BoxShadow(color: Colors.grey.shade300,blurRadius: 10)]),
                            child: Row(children: [
                              Image.asset("assets/icon/flag/${index+1}.png",),
                              SizedBox(width: 15,),
                              Text(getController.supportedLangList[index],style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 17),),
                              Spacer(),
                              isselected == index ?  const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.black,
                                  ):SizedBox(),
                              SizedBox(width: 10,),
                            ],),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                          if (getController.supportedLangList[isselected!] == "French") {
                            changeLanguage("fr");
                          }else if (getController.supportedLangList[isselected!] == "Spanish") {
                            changeLanguage('es');
                          }else if (getController.supportedLangList[isselected!] == "Italian") {
                            changeLanguage('it');
                          }else if (getController.supportedLangList[isselected!] == "Arabic") {
                            changeLanguage('ar');
                          }else if (getController.supportedLangList[isselected!] == "Hindi") {
                            changeLanguage('hi');
                          }else if (getController.supportedLangList[isselected!] == "Chinese") {
                            changeLanguage('cn');
                          }else if (getController.supportedLangList[isselected!] == "Portuguese") {
                            changeLanguage('pt');
                          } else if (getController.supportedLangList[isselected!] == "Russian") {
                            changeLanguage('ru');
                          } else if (getController.supportedLangList[isselected!] == "English") {
                            changeLanguage('en');
                          } else {
                            changeLanguage('en');
                          }
                          getController.checkCountry(context );

                          Navigator.pop(context);
              },
              child: Container(
                height: 55,
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // color: const Color(0XFFDF0000),
                  gradient:  LinearGradient(
                    colors: [
                      primary,
                      primary2
                      // Color(0XFFDF0000),
                      // Color(0XFFFAB0AF),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    "${lang?.translate("Confirm")}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }


}
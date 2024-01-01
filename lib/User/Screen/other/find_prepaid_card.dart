import 'package:ceyron_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../utils/next_screen.dart';


class FindCard extends StatefulWidget {
  const FindCard({super.key});

  @override
  State<FindCard> createState() => _FindCardState();
}

class _FindCardState extends State<FindCard> {
  TextEditingController numberController = TextEditingController();
  String? number;
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
        title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
              onTap: (){Navigator.pop(context);},
              child: Icon(Icons.arrow_back,color: Colors.black,)),
          SizedBox(width: 5,),
          Container(height: 45,width: 45,decoration: BoxDecoration(shape: BoxShape.circle,image: DecorationImage(image:AssetImage('assets/image/user.png') )),),
          SizedBox(width: 15,),
          Text('Hello!',style: TextStyle(color: Colors.black,fontSize: 15),),
          Spacer(),
          Image.asset('assets/icon/notifiction.png',scale: 20,),
          SizedBox(width: 10,),
          Text('KYC',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18),),
        ],
      ),),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Text("Find Prepaid Card",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            SizedBox(height: 10,),
            Form(
            key: _formKey,
            child: Container(
                child:IntlPhoneField(
                  decoration: InputDecoration( //decoration for Input Field
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  validator: (value) {
                    if (value==null) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                  initialCountryCode: 'IN',
                   controller: numberController,
                  onChanged: (phone) {
                     number= phone.completeNumber;
                  },
                )
            ),
          ),
            comContainer(context, 40.toDouble(), 100.toDouble(), "Search"),
            SizedBox(height: 20,),
            Text("Available Prepaid Card",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) => Container(
                height: 55,
                margin: EdgeInsets.all(5),
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 5
                    )]
                ),
                child: Row(children: [
                  Image.asset('assets/icon/atmcard.png',scale: 12,),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('**********3050',style: TextStyle(fontWeight: FontWeight.w500),),
                      Text('Prepaid Card',style: TextStyle(fontSize: 13),),
                    ],
                  ),
                  Spacer(),
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value){
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                  ),
                ],),
              ),),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 45,
                  width: 120,
                  decoration: BoxDecoration(
                      border: Border.all(color: primary.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(10),color: primary2.withOpacity(0.1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(Icons.add,color: primary,),
                    SizedBox(width: 5,),
                    Text("ADD",style: TextStyle(fontWeight: FontWeight.w500,color: primary),)
                  ],),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("OR",style: TextStyle(fontWeight: FontWeight.w500,color: primary,fontSize: 18),)
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, 'AddCard');
                  },
                  child: Container(
                    height: 45,
                    width: 220,
                    alignment: Alignment.center,
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
                          color: const Color(0xFF4C2E84).withOpacity(0.2),
                          offset: const Offset(0, 15.0),
                          blurRadius: 60.0,
                        ),
                      ],
                    ),
                      child: Text("ADD New Prepaid Card",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,)

        ],),
      )

    );
  }
}

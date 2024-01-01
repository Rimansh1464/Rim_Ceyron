import 'package:ceyron_app/Api/Model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../Agent/AppBar/appbar.dart';
import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../Api/Controller/transaction_provider.dart';
import '../../Api/Model/transaction_model.dart';
import '../Screen/show_agent_details.dart';

class ShowAgent extends StatefulWidget {
  const ShowAgent({key});

  @override
  State<ShowAgent> createState() => _ShowAgentState();
}

class _ShowAgentState extends State<ShowAgent> {
  String? firstLetter;
  String? lastname;
  TextEditingController editingController = TextEditingController();
  Future<List<UserData>>? futureUserDataList; // List of Future<UserData>
  void fetchUserData(String? query) {
    final ts = context.read<TransactionProvider>();
    final sp = context.read<AuthProvider>();

    Future<List<UserData>> userDataFutures = ts.getAgentData(query ?? sp.userData?.country);
    setState(() {
      futureUserDataList = userDataFutures;
    });
  }
  Widget getCharacter(String first,String last) {
    firstLetter = first.isNotEmpty ? first[0] : '?';
    lastname = last.isNotEmpty ? last[0] : '?';
    return Container(
      height: 75,
      width: 75,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: Text("$firstLetter/$lastname",
        style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 25,color: Colors.white),
      ),
    );
  }
  Future getData() async {
    final sp = context.read<AuthProvider>();
    final ts = context.read<TransactionProvider>();
    // sp.getUserData();
    // sp.updateData(context);
    ts.insertAgentData(sp.userData?.country);
  }
  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      fetchUserData(query);
    } else {
      final ts = context.read<TransactionProvider>();
      final sp = context.read<AuthProvider>();
      Future<List<UserData>> userDataFutures = ts.getAgentData(sp.userData?.country);
      setState(() {
        futureUserDataList = userDataFutures;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getData();
    final sp = context.read<AuthProvider>();
    fetchUserData(sp.userData?.country);
  }
  @override
  Widget build(BuildContext context) {
    TransactionProvider Tr = Provider.of<TransactionProvider>(context,listen: false);
    AuthProvider AuP = Provider.of<AuthProvider>(context,listen: false);
    var lang = LocalizationStuff.of(context);
    return Scaffold(
      appBar:CustomAppBar2(title: "${lang?.translate("Search Agent")}",),
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    hintText: "${lang?.translate("search using city/state name")}",
                    prefixIcon: Icon(Icons.search),
                    // suffixIcon: Icon(Icons.cancel_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<UserData>>(
                future: futureUserDataList,
                builder: (context, snapshot) {
                  List<UserData>? Data = snapshot.data?.cast<UserData>();

                  print("Data===${snapshot.data?.length}");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return  Center(child:   Lottie.asset(
                        'assets/lottie/no_data.json',height: 250
                    ));
                  } else {
                    if(Data!.isEmpty){
                      return Center(child: Lottie.asset(
                          'assets/lottie/no_data.json',height: 250
                      ));
                    }else{
                      return ListView.builder(
                          itemCount: Data?.length,
                          itemBuilder: (c,i){
                            List<String>? nameParts =Data[i].name.split(" ");
                            String? initials = nameParts?.map((part) => part[0]).join('');
                            return GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>  ShowAgentDetails(Data: Data[i],)));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        spreadRadius: 0.5,
                                        blurRadius: 1.5
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        //getCharacter(names[i],''),
                                        Container(
                                          height: 55,
                                          width: 55,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue,
                                          ),
                                          child: Text("${initials}",
                                            style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 22  ,color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${Data?[i].businessName}",
                                                style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 20),
                                              ),
                                              SizedBox(height: 10,),
                                              Wrap(children: [
                                                Text("Address: ${Data?[i].address}"),
                                              ],),
                                              SizedBox(height: 5,),
                                              Wrap(children: [
                                                Row(
                                                  children: [
                                                    Text("State: ${Data?[i].state}"),
                                                    const Spacer(),
                                                    Text("Country: ${Data?[i].country}"),

                                                  ],
                                                ),
                                              ],)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    }

                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

}

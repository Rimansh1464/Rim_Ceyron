import 'package:flutter/material.dart';

import '../../../utils/colors.dart';


class Add_Money extends StatefulWidget {
  String title;

  Add_Money(this.title);

  @override
  State<Add_Money> createState() => _Add_MoneyState();
}

class _Add_MoneyState extends State<Add_Money>
    with SingleTickerProviderStateMixin {
  String selectedCurrency = "USD";
  List<String> _currencyOptions = ["USD", "INR", 'EUR', 'GBP', 'JPY '];
  TabController? tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('assets/image/user.png'))),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              widget.title,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Spacer(),
            Image.asset(
              'assets/icon/notifiction.png',
              scale: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'KYC',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Image.asset("assets/image/wallet.png", scale: 3),
          SizedBox(height: 10),
          Text(
            "Available Balance: 21528.02",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: primary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10)),
            height: 50,
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Amount",
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintStyle: TextStyle(color: Colors.white60)),
                )),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                  decoration: BoxDecoration(
                      color: primary,
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 5),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          style: TextStyle(color: Colors.white),
                          dropdownColor: primary,
                          iconEnabledColor: Colors.white,
                          value: selectedCurrency,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCurrency = newValue!;
                            });
                          },
                          items: _currencyOptions.map((String currency) {
                            return DropdownMenuItem<String>(
                              value: currency,
                              child: Text(
                                currency,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Pay Through",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Container(
            height: 40,
            color: primary.withOpacity(0.1),
            child: TabBar(
              indicatorColor: primary,
              controller: tabController,
              tabs: [
                Text(
                  "Card",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Bank Account",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Prepaid Card",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  selectedindex = index;
                                });
                              },
                              leading: Image.asset(
                                "assets/icon/atmcard.png",
                                scale: 15,
                              ),
                              title: Text(
                                "**** **** **** 3569",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("Jacob Charls"),
                              trailing: selectedindex == index
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                    )
                                  : Icon(Icons.circle_outlined),
                            );
                          },
                          shrinkWrap: true,
                          itemCount: 2),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.65,
                      decoration: BoxDecoration(
                          border: Border.all(color: primary.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10),
                          color: primary2.withOpacity(0.1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: primary,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "ADD NEW PREPAID CARD.",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: primary),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width * 0.80,
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
                        child: Text(
                          "Add Money",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  selectedindex2 = index;
                                });
                              },
                              leading: Image.asset(
                                "assets/icon/atmcard.png",
                                scale: 15,
                              ),
                              title: Text(
                                "**** **** **** 3569",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("Jacob Charls"),
                              trailing: selectedindex2 == index
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                    )
                                  : Icon(Icons.circle_outlined),
                            );
                          },
                          shrinkWrap: true,
                          itemCount: 2),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.65,
                      decoration: BoxDecoration(
                          border: Border.all(color: primary.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10),
                          color: primary2.withOpacity(0.1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: primary,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "ADD NEW PREPAID CARD.",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: primary),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width * 0.80,
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
                        child: Text(
                          "Add Money",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  selectedindex3 = index;
                                });
                              },
                              leading: Image.asset(
                                "assets/icon/atmcard.png",
                                scale: 15,
                              ),
                              title: Text(
                                "**** **** **** 3569",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("Jacob Charls"),
                              trailing: selectedindex3 == index
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                    )
                                  : Icon(Icons.circle_outlined),
                            );
                          },
                          shrinkWrap: true,
                          itemCount: 2),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.65,
                      decoration: BoxDecoration(
                          border: Border.all(color: primary.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10),
                          color: primary2.withOpacity(0.1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: primary,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "ADD NEW PREPAID CARD.",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: primary),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width * 0.80,
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
                        child: Text(
                          "Add Money",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }

  int selectedindex = 0;
  int selectedindex2 = 0;
  int selectedindex3 = 0;
}

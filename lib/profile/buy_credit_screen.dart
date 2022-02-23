import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class BuyCredit extends StatefulWidget {
  @override
  _BuyCreditState createState() => _BuyCreditState();
}

class _BuyCreditState extends State<BuyCredit> {
  int _value = 1;
  String image;

  bool value = true;
  int selectedCard = 0;

  @override
  void initState() {
    super.initState();
    image =
        "https://i.pinimg.com/originals/bc/9b/f4/bc9bf465006846b84c8f4d1d53709a0f.png";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: size.height * 0.3,
            width: size.width,
            child: CustomPaint(
              painter: CurvePainter(),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Available Credits",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 35),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "1000",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Image.network(
                            image,
                            width: 25,
                          )
                        ],
                      )
                    ],
                  ),
                  Positioned(
                    top: 20,
                    left: 5,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        // size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Buy Credits",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton(
                      dropdownColor: Colors.grey[200],
                      isExpanded: false,
                      underline: Container(
                        width: 0,
                        height: 0,
                      ),
                      elevation: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                      value: _value,
                      items: [
                        DropdownMenuItem(
                          child: Text("1000"),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text("2000"),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Text("3000"),
                          value: 3,
                        ),
                        DropdownMenuItem(
                          child: Text("4000"),
                          value: 4,
                        ),
                        DropdownMenuItem(
                          child: Text("5000"),
                          value: 5,
                        ),
                      ],
                      onChanged: (dynamic value) {
                        setState(() {
                          _value = value;
                        });
                      },
                      hint: Text("Select item")),
                ),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Stack(
                            alignment: Alignment.center,
                            overflow: Overflow.visible,
                            children: [
                              bottomsheet(),
                              Positioned(
                                top: -105,
                                // left: 0,
                                // right: 0,
                                child: Container(
                                  height: size.height * 0.2,
                                  width: size.width / 2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          'https://cdn.trendhunterstatic.com/thumbs/mastercard-logo.jpeg',
                                        ),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: Text(
                    "BUY",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
            child: Container(
              color: Colors.white,
            ),
          ),
          Container(
            color: Colors.white,
            child: Divider(
              thickness: 1,
              height: 0,
            ),
          ),
          Container(
            width: size.width,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Text(
              "History",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 100),
            color: Colors.white,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(),
                  Text(
                    "Credit",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text(
                    "Balance",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: 10),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black)),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Audio Buy"),
                        Text("100"),
                        Text("800"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = primaryColor;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.80);
    path.quadraticBezierTo(
        size.width / 2, size.height / 1, size.width, size.height * 0.80);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class bottomsheet extends StatefulWidget {
  @override
  _bottomsheetState createState() => _bottomsheetState();
}

class _bottomsheetState extends State<bottomsheet> {
  TextEditingController cardnumber = TextEditingController();

  TextEditingController expired = TextEditingController();

  TextEditingController cvv = TextEditingController();

  TextEditingController name = TextEditingController();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String Cardnumber = "";
  String Cardexpiredate = "";
  String Cardcvv = "";
  String CardHoldername = "";
  int _value = 1;
  bool isChecked = false;

  String image;

  bool value = true;
  int selectedCard = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.7,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Stack(
        children: [
          Container(
            height: size.height * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: size.height * 0.07, right: 20, left: 20),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Credit/Debit card',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'bold',
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: cardnumber,
                              // ignore: missing_return
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Enter Card Number";
                                }
                              },
                              onSaved: (val) {
                                setState(() {
                                  Cardnumber = val;
                                });
                              },
                              decoration: transparentInputDecoration.copyWith(
                                  hintText: "Card number",
                                  isCollapsed: false,
                                  fillColor: Color(0xffe7e7e7),
                                  filled: true,
                                  hintStyle: TextStyle(
                                      color: Color(0xff9d9d9d), fontSize: 15)),
                              // hint: 'Card number',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    // ignore: missing_return
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return "Enter Card Expired Date";
                                      }
                                    },
                                    controller: expired,
                                    onSaved: (val) {
                                      setState(() {
                                        Cardexpiredate = val;
                                      });
                                    },
                                    decoration:
                                        transparentInputDecoration.copyWith(
                                            hintText: "Expired",
                                            isCollapsed: false,
                                            fillColor: Color(0xffe7e7e7),
                                            filled: true,
                                            hintStyle: TextStyle(
                                                color: Color(0xff9d9d9d),
                                                fontSize: 15)),
                                    // hint: 'Expired',
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: cvv,
                                    // ignore: missing_return
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return "Enter Card Cvv";
                                      }
                                    },
                                    onSaved: (val) {
                                      setState(() {
                                        Cardcvv = val;
                                      });
                                    },
                                    decoration:
                                        transparentInputDecoration.copyWith(
                                            hintText: "CVV",
                                            isCollapsed: false,
                                            fillColor: Color(0xffe7e7e7),
                                            filled: true,
                                            hintStyle: TextStyle(
                                                color: Color(0xff9d9d9d),
                                                fontSize: 15)),
                                    // hint: 'CVV',
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: name,
                              // ignore: missing_return
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Enter Card Holder Name";
                                }
                              },
                              onSaved: (val) {
                                setState(() {
                                  CardHoldername = val;
                                });
                              },
                              decoration: transparentInputDecoration.copyWith(
                                  isCollapsed: false,
                                  hintText: "Cardholder Name",
                                  fillColor: Color(0xffe7e7e7),
                                  filled: true,
                                  hintStyle: TextStyle(
                                      color: Color(0xff9d9d9d), fontSize: 15)),
                              // hint: 'Cardholder Name',
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.black,
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.grey[300]),
                                  value: isChecked,
                                  // shape:,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isChecked = value;
                                    });
                                  },
                                ),
                                Text(
                                  'Save card Information',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                if (_formkey.currentState.validate()) {
                                  _formkey.currentState.save();
                                  setState(() {
                                    cardnumber.clear();
                                    cvv.clear();
                                    name.clear();
                                    expired.clear();
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    "Add Card",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Container(
                                  height: 180,
                                  width: size.width * 0.8,
                                  decoration: BoxDecoration(
                                    color: Color(0xff5d5d5d),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ListView.builder(
                                      itemCount: 1,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedCard = index;
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Image.network(
                                                          'https://cdn.trendhunterstatic.com/thumbs/mastercard-logo.jpeg',
                                                          height: 30,
                                                          width: 40,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.02,
                                                        ),
                                                        Text(
                                                          '123456789',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'bold',
                                                              fontSize: 15),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Container(
                                                        height: 12,
                                                        width: 12,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: selectedCard ==
                                                                        index
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .transparent,
                                                                width: 2),
                                                            shape: BoxShape
                                                                .circle),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.1, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            // showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return ConfirmationScreen();
                            //     });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff454545),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              child: Row(
                                children: [
                                  Text(
                                    'Pay Now',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'bold',
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 12,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '\$1.00',
                              style: TextStyle(
                                  fontSize: 21, color: Color(0xff9d9d9d)),
                            ),
                            Text(
                              'Exclusive of Taxes',
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xff9d9d9d)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration transparentInputDecoration = InputDecoration(
    border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(8)),
    enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.transparent)),
    disabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.transparent)),
    focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.transparent)),
    isCollapsed: true,
    counterText: "");

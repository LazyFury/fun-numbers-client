import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funnumbers/pages/submit.dart';
import 'package:funnumbers/widgets/safeStatusBar.dart';
import 'package:funnumbers/widgets/touchView.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api.dart';

class HomePage extends StatefulWidget {
  final String title;
  HomePage({this.title}) : super();
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  String reqTemplate(int num, String type) {
    return "/${num.toString()}/${type ?? ''}";
  }

  String type = "";
  String text = "wait for refresh.";
  int num = 5;
  String inputValue = '';
  TextEditingController inputController = new TextEditingController();

  void initState() {
    super.initState();
    req();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  req() {
    API.instance.get<String>(reqTemplate(num, type)).then((value) {
      print(value);
      setState(() {
        text = value.data;
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Column(
          children: [
            SafeStatusBar(),
            Title(title: widget.title),
            TypeButtonGroup(type, updateReqType),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              height: 1,
            ),
            searchView(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Column(
                        children: [
                          showNumber(num, (_num) {
                            setState(() {
                              num = _num;
                              req();
                            });
                          }),
                          ShowTheNum(text: text),
                          // random
                          TouchView(
                              onTap: () {
                                setState(() {
                                  num = new Random().nextInt(399);
                                });
                                req();
                              },
                              child: Container(
                                  child: Text("Random",
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.white, fontSize: 20)),
                                  decoration:
                                      BoxDecoration(color: Colors.black),
                                  padding: EdgeInsets.all(10))),
                        ],
                      );
                    }, childCount: 1),
                  )
                ],
              ),
            ),
            TouchView(
              child: Container(
                margin: EdgeInsets.only(bottom: 30, top: 20),
                child: Text(
                  "submit a fun fact about the number",
                  style: GoogleFonts.aBeeZee(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Submit(
                            num: num,
                            type: type,
                          )),
                );
              },
            ),
            Container(
              child: Text(
                  "it`s a free application.\n Thanks for the numbers api.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.aBeeZee(
                      fontSize: 18, color: Colors.grey[400])),
            ),
            SafeAreaBottom()
          ],
        ),
      ),
    );
  }

  Container searchView() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(99)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: inputController,
              onChanged: (value) {
                print(inputValue);
                if (RegExp(r'^\d+$').hasMatch(value)) {
                  setState(() {
                    inputValue = value;
                  });
                } else {
                  inputController?.text = "";
                }
              },
              autofocus: false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter a number and see what happens..."),
              keyboardType: TextInputType.number,
            ),
          ),
          AnimatedOpacity(
            duration: Duration(microseconds: 1),
            opacity: inputValue == "" ? 0 : 1,
            child: TouchView(
                onTap: () {
                  print(inputController);
                  inputController?.clear();
                  setState(() {
                    inputValue = '';
                  });
                },
                child: Icon(CupertinoIcons.clear_circled_solid)),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: TouchView(
                onTap: () {
                  try {
                    int _num = int.parse(inputValue);
                    setState(() {
                      num = _num;
                    });
                  } catch (err) {}
                  req();
                },
                child: Text("Search",
                    style: GoogleFonts.aBeeZee(
                        fontSize: 24, fontWeight: FontWeight.bold))),
          )
        ],
      ),
    );
  }

  updateReqType(String _type) {
    setState(() {
      type = _type;
      req();
    });
  }
}

Widget showNumber(int num, void onChanged(int num)) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TouchView(
        onTap: () => onChanged(++num),
        child: Container(
          child: Icon(CupertinoIcons.triangle_fill, size: 32),
          margin: EdgeInsets.only(right: 18),
        ),
      ),
      Text(num.toString(), style: GoogleFonts.anton(fontSize: 48)),
      TouchView(
        onTap: () => onChanged(--num),
        child: Container(
            child: RotatedBox(
              quarterTurns: 2,
              child: Icon(
                CupertinoIcons.triangle_fill,
                size: 32,
              ),
            ),
            margin: EdgeInsets.only(left: 18)),
      ),
    ],
  );
}

// ignore: non_constant_identifier_names
ButtonBar TypeButtonGroup(String type, void onchange(String type)) {
  return ButtonBar(
    alignment: MainAxisAlignment.center,
    children: [
      changeTypeBtn(null, type == null, onchange),
      changeTypeBtn("math", type == "math", onchange),
      changeTypeBtn("year", type == "year", onchange),
      changeTypeBtn("date", type == "date", onchange),
      changeTypeBtn("trivia", type == "trivia", onchange),
    ],
  );
}

TextButton changeTypeBtn(
        String _type, bool isSelect, void onChanged(String type)) =>
    TextButton(
        onPressed: () => onChanged(_type),
        child: Text(
          _type ?? "All",
          style: GoogleFonts.aBeeZee(
              color: isSelect ? Colors.blue : Colors.black, fontSize: 20),
        ),
        style: ButtonStyle());

class Title extends StatelessWidget {
  const Title({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      child: Text(title ?? "-",
          style: GoogleFonts.breeSerif(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              backgroundColor: Colors.black)),
    );
  }
}

class ShowTheNum extends StatelessWidget {
  const ShowTheNum({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        style: GoogleFonts.aBeeZee(fontSize: 36),
        textAlign: TextAlign.center,
      ),
    );
  }
}

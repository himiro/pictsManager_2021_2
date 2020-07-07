import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import 'Widget/InputFieldArea.dart';
import 'Widget/bezierContainer.dart';
import 'package:http/http.dart' as http;
import '../src/constants/constant.dart' as Constants;


import 'homePage.dart';


class SharePage extends StatefulWidget {

  static const routeName = '/passArguments';

  final String imageUrl;

  // This Widget accepts the arguments as constructor parameters. It does not
  // extract the arguments from the ModalRoute.
  //
  // The arguments are extracted by the onGenerateRoute function provided to the
  // MaterialApp widget.
  SharePage({Key key,
    @required this.imageUrl,}) : super(key: key);


  @override
  _SharePageState createState() => _SharePageState(this.imageUrl);
}

class _SharePageState extends State<SharePage> {
  final _emailController = TextEditingController();

  final String imageUrl;

  _SharePageState(@required this.imageUrl);


  @override
  Future<void> initState() {
    super.initState();
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Share',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'Your',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'Photo',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        InputFieldArea(
          controller: _emailController,
          obscureText: false,
          title: "Email id",
        ),
      ],
    );
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomePage()));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Erreur Connection"),
          contentPadding: EdgeInsets.symmetric(vertical: 15),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xfffbb448), Color(0xfff7892b)])),
              child: FlatButton(
                child: new Text("Close",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<http.Response> shareImage(String imageUrl, String email) {
    print(imageUrl);
    print(email);
    return http.post(
      'http://' +
          Constants.IP_HOST +
          ':' +
          Constants.PORT_HOST +
          '/files/share',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": storage.getItem('token')
      },
      body: jsonEncode(<String, String>{
        'img_name': imageUrl,
        'email': email,
      }),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        final http.Response response =
        await shareImage(this.imageUrl, _emailController.text);
        if (response.statusCode == 200) {
          // If the server did return a 201 CREATED response,
          // then parse the JSON.
          print(json.decode(response.body));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          // If the server did not return a 201 CREATED response,
          // then throw an exception.
          throw Exception('Failed to share photos');
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Share',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(height: 50),
                  _emailPasswordWidget(),
                  SizedBox(height: 20),
                  _submitButton(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }
}

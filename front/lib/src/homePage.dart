import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:frefresh/frefresh.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:http/http.dart';
import 'package:image_editor_pro/image_editor_pro.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tdev800/src/addTagPage.dart';
import 'package:tdev800/src/sharePage.dart';
import 'package:tdev800/src/takePhotoPage.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

import '../main.dart';
import 'Widget/InputFieldArea.dart';
import 'Widget/bezierContainer.dart';
import '../src/constants/constant.dart' as Constants;

List<Widget> images = new List<Widget>();
List<dynamic> imageFiles;
List<dynamic> imagelist;
List<dynamic> sharedImagelist;
List _items;
List<dynamic> _currentTag = List<dynamic>();

FRefreshController controller = FRefreshController();

final _emailController = TextEditingController();

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  var isLoaded = false;

  @override
  Future<void> initState() {
    super.initState();
  }

  Future _getImages() async {
    Map<String, String> headers = {"Authorization": storage.getItem('token')};
    if (_currentTag.length <= 0) {
      var request = http.MultipartRequest(
          'GET',
          Uri.parse('http://' +
              Constants.IP_HOST +
              ':' +
              Constants.PORT_HOST +
              '/files'));
      request.headers.addAll(headers);
      var respondStreamed = await request.send();
      var response = await http.Response.fromStream(respondStreamed);
      imagelist = jsonDecode(response.body);
//      setState(() { imagelist = jsonDecode(response.body); });
    } else {
      var request4 = http.MultipartRequest(
          'GET',
          Uri.parse('http://' +
              Constants.IP_HOST +
              ':' +
              Constants.PORT_HOST +
              '/files?search=' +
              _currentTag[0].title));
      request4.headers.addAll(headers);
      var respondStreamed4 = await request4.send();
      var response4 = await http.Response.fromStream(respondStreamed4);
      imagelist = jsonDecode(response4.body);
      //setState(() { imagelist = jsonDecode(response4.body); });
    }
    var request3 = http.MultipartRequest(
        'GET',
        Uri.parse('http://' +
            Constants.IP_HOST +
            ':' +
            Constants.PORT_HOST +
            '/files/tags'));
    request3.headers.addAll(headers);
    var respondStreamed3 = await request3.send();
    var response3 = await http.Response.fromStream(respondStreamed3);
    _items = jsonDecode(response3.body);
//    setState(() { _items = jsonDecode(response3.body);});


    var request2 = http.MultipartRequest(
        'GET',
        Uri.parse('http://' +
            Constants.IP_HOST +
            ':' +
            Constants.PORT_HOST +
            '/files/share'));
    request2.headers.addAll(headers);
    var respondStreamed2 = await request2.send();
    var response2 = await http.Response.fromStream(respondStreamed2);
//    setState(() { sharedImagelist = jsonDecode(response2.body);});
    sharedImagelist = jsonDecode(response2.body);
    while (imagelist == null && sharedImagelist == null) {
      isLoaded = false;
    }
    isLoaded = true;

    return sharedImagelist;
  }

  Widget _photoButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        _showCamera();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
            ),
            Icon(
              Icons.add_a_photo,
              color: Colors.black,
              size: 24.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
          ],
        ),
      ),
    );
  }

  void _showCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TakePhotoPage(camera: camera)));
  }

  Widget _sharedImageGalery() {
    final heightapp = MediaQuery.of(context).size.height;
    final margin = heightapp * 0.2;
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.only(top: 10),
          sliver: SliverGrid.count(
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: 2,
            children: List.generate(sharedImagelist.length, (index) {
              return InkWell(
                  onTap: () {
                    _showImageDialog(sharedImagelist[index], true);
                  },
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: "http://" +
                        Constants.IP_HOST +
                        ":" +
                        Constants.PORT_HOST +
                        "/files/share/" +
                        sharedImagelist[index],
                    httpHeaders: {
                      "Authorization": storage.getItem('token'),
                    },
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fadeOutDuration: const Duration(seconds: 1),
                    fadeInDuration: const Duration(seconds: 3),
                  ));
            }),
          ),
        ),
      ],
    );
  }

  Widget _imageGalery() {
    final heightapp = MediaQuery.of(context).size.height;
    final margin = heightapp * 0.2;
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.only(top: 10),
          sliver: SliverGrid.count(
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: 2,
            children: List.generate(imagelist.length, (index) {
              return InkWell(
                  onTap: () {
                    _showImageDialog(imagelist[index], false);
                  },
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: "http://" +
                        Constants.IP_HOST +
                        ":" +
                        Constants.PORT_HOST +
                        "/files/" +
                        imagelist[index],
                    httpHeaders: {
                      "Authorization": storage.getItem('token'),
                    },
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fadeOutDuration: const Duration(seconds: 1),
                    fadeInDuration: const Duration(seconds: 3),
                  ));
            }),
          ),
        ),
      ],
    );
  }

  Widget _content(int page) {
    switch (currentPage) {
      case 0:
        return _basicContent();
      case 1:
        return _imageGalery();
      case 2:
        return _sharedImageGalery();
      default:
        return _basicContent();
    }
  }

  Widget _basicContent() {
    return SingleChildScrollView(
      child: Center(
        child: Column(children: <Widget>[
          Tags(
            itemCount: _items.length, // required
            itemBuilder: (int index) {
              final item = _items[index];

              return ItemTags(
                // Each ItemTags must contain a Key. Keys allow Flutter to
                // uniquely identify widgets.
                key: Key(index.toString()),
                index: index,
                // required
                title: item,
                active: false,
                textStyle: TextStyle(
                  fontSize: 12,
                ),
                combine: ItemTagsCombine.withTextBefore,
                image: ItemTagsImage(
                    image: AssetImage(
                        "img.jpg") // OR NetworkImage("https://...image.png")
                    ),
                // OR null,
                icon: ItemTagsIcon(
                  icon: Icons.add,
                ),
                // OR null,
                removeButton: ItemTagsRemoveButton(
                  onRemoved: () {
                    // Remove the item from the data source.
                    setState(() {
                      // required
                      _items.removeAt(index);
                    });
                    //required
                    return true;
                  },
                ),
                // OR null,
                onPressed: (item) => chercherImage(item),
                onLongPressed: (item) => print(item),
              );
            },
          ),
          Container(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(imagelist.length, (index) {
                  return InkWell(
                      onTap: () {
                        _showImageDialog(imagelist[index], false);
                      },
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: "http://" +
                            Constants.IP_HOST +
                            ":" +
                            Constants.PORT_HOST +
                            "/files/" +
                            imagelist[index],
                        httpHeaders: {
                          "Authorization": storage.getItem('token'),
                        },
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fadeOutDuration: const Duration(seconds: 1),
                        fadeInDuration: const Duration(seconds: 3),
                      ));
                }),
              ))
        ]),
      ),
    );
  }

  Future<void> chercherImage(var items) async {
    if (items.active) {
      _currentTag = List<dynamic>();
      _currentTag.add(items);
      setState(() {

      });
    } else {
      _currentTag = List<dynamic>();
      setState(() {

      });
    }
  }

  void _showImageDialog(String imageURL, bool shared) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Edit you photo"),
//          contentPadding: EdgeInsets.symmetric(vertical: 15),
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
              ),
              child: Column(children: <Widget>[
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: "http://" +
                      Constants.IP_HOST +
                      ":" +
                      Constants.PORT_HOST +
                      "/files/" +
                      imageURL,
                  httpHeaders: {
                    "Authorization": storage.getItem('token'),
                  },
                  placeholder: (BuildContext context, String url) => Container(
                    width: 320,
                    height: 240,
                    color: Colors.purple,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 20.0,
                            semanticLabel:
                                'Text to announce in accessibility modes',
                          ),
                          Text("Edit")
                        ],
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () async {
                        final http.Response response =
                            await deleteImage(imageURL, shared);
                        if (response.statusCode == 200) {
                          // If the server did return a 201 CREATED response,
                          // then parse the JSON.
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        } else {
                          // If the server did not return a 201 CREATED response,
                          // then throw an exception.
                          throw Exception('Failed to share photos');
                        }
                      },
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Icon(
                            Icons.delete_outline,
                            color: Colors.black,
                            size: 20.0,
                            semanticLabel:
                                'Text to announce in accessibility modes',
                          ),
                          Text("Delete")
                        ],
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddTagPage(imageUrl: imageURL)));
                      },
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Icon(
                            Icons.bookmark,
                            color: Colors.black,
                            size: 20.0,
                            semanticLabel:
                                'Text to announce in accessibility modes',
                          ),
                          Text("Tagg")
                        ],
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SharePage(imageUrl: imageURL)));
                      },
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Icon(
                            Icons.share,
                            color: Colors.black,
                            size: 20.0,
                            semanticLabel:
                                'Text to announce in accessibility modes',
                          ),
                          Text("Share")
                        ],
                      ),
                    )),
                  ]),
                )
              ]),
            )
          ],
        );
      },
    );
  }

  Future<http.Response> deleteImage(String imageUrl, bool shared) {
    if (shared) {
      return http.delete(
        'http://' +
            Constants.IP_HOST +
            ':' +
            Constants.PORT_HOST +
            '/files/share/' +
            imageUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": storage.getItem('token')
        },
      );
    } else {
      return http.delete(
        'http://' +
            Constants.IP_HOST +
            ':' +
            Constants.PORT_HOST +
            '/files/' +
            imageUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": storage.getItem('token')
        },
      );
    }
  }

  Widget projectWidget() {
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }
        return Container(
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              SizedBox(height: height * .2),
              SizedBox(height: 50),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.only(top: 20),
                  child: _content(currentPage)),
            ],
          ),
        );
      },
      future: _getImages(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Color(0xfffbb448),
        backgroundColorEnd: Color(0xffe46b10),
        title: const Text('Your photos'),
        actions: <Widget>[
          _photoButton()
          // action button
        ],
      ),
      body: projectWidget(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() {
          currentPage = value;
        }),
        currentIndex: currentPage,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.image),
            title: Text('Basic'),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_on),
            title: Text('GridView'),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('FavView'),
          ),
        ],
      ),
    );
  }
}

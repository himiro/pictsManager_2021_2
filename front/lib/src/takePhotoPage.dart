import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tdev800/main.dart';

import 'Widget/bezierContainer.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

import 'compressor.dart';
import 'homePage.dart';
import '../src/constants/constant.dart' as Constants;

class TakePhotoPage extends StatefulWidget {
  TakePhotoPage({Key key, this.title, @required this.camera}) : super(key: key);

  final CameraDescription camera;

  final String title;

  @override
  _TakePhotoPageState createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  CameraController _cameraController;
  Future<void> _initializeCameraControllerFuture;

  @override
  void initState() {
    super.initState();

    _cameraController =
        CameraController(widget.camera, ResolutionPreset.medium);

    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  void _takePicture(BuildContext context) async {
    try {
      await _initializeCameraControllerFuture;

      final path =
          join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');

      Directory tempDir = await getTemporaryDirectory();

      await _cameraController.takePicture(path);

      CompressObject compressObject = CompressObject(
        imageFile: File('$path'),
        //image
        path: tempDir.path,
        //compress to path
        quality: 20,
        //first compress quality, default 80
        step: 2,
        //compress quality step, The bigger the fast, Smaller is more accurate, default 6
        mode: CompressMode.AUTO, //default AUTO
      );
      Compressor.compressImage(compressObject).then((_path) {
        setState(() {
          uploadImage(_path);
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          )
              .then((_) {
            setState(() {});
          });
        });
      });
    } catch (e) {
    }
  }

  Future<http.StreamedResponse> uploadImage(String path) async {
    Map<String, String> headers = {"Authorization": storage.getItem('token')};
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://' + Constants.IP_HOST + ':' + Constants.PORT_HOST + '/files'));
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath('file', path));
    return await request.send();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          FutureBuilder(
            future: _initializeCameraControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_cameraController);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.camera),
                  onPressed: () {
                    _takePicture(context);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}

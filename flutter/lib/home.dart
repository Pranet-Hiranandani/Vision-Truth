import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool processing = false;
  bool done = false;
  String result = "";
  bool people = false;
  late File fileimage;
  int confidence = 0;

  Future get_image() async {
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      setState(
        () {
          fileimage = File(file.path);
          processing = true;
          detect(file.path);
        },
      );
    }
  }

  Future detect(String path) async {
    if (people == true) {
      Tflite.close();
      await Tflite.loadModel(
        model: "assets/tflite/modelpeople.tflite",
        isAsset: true,
      );
      var recognitions;
      recognitions = await Tflite.runModelOnImage(
        path: path,
        numResults: 2,
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0// defaults to 5
        threshold: 0.2,
      );
      Tflite.close();
      print(recognitions);
      if (recognitions == null) {
        var button = ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"));
        var alert = AlertDialog(
          actions: [button],
          content: Text(
            "There was an error with the AI algorithm",
            textAlign: TextAlign.center,
          ),
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
      setState(
        () {
          confidence = recognitions?[0].confidence.toInt();
          if (recognitions?[0].index == 0) {
            result = "We are $confidence% sure that your image is Fake";
            done = true;
          }
          if (recognitions?[0].index == 1) {
            result = "We are $confidence% sure that your image is Real";
            done = true;
          }
        },
      );
    } else {
      Tflite.close();
      await Tflite.loadModel(
        model: "assets/tflite/modellandscape.tflite",
        isAsset: true,
      );
      var recognitions = await Tflite.runModelOnImage(
        path: fileimage.path,
        numResults: 2,
      );
      if (recognitions == null) {
        var button = ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"));
        var alert = AlertDialog(
          actions: [button],
          content: Text(
            "There was an error with the AI algorithm",
            textAlign: TextAlign.center,
          ),
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
      setState(
        () {
          confidence = recognitions?[0].confidence.toInt();
          if (recognitions?[0].index == 0) {
            result = "We are $confidence% sure that your image is Fake";
            done = true;
          }
          if (recognitions?[0].index == 1) {
            result = "We are $confidence% sure that your image is Real";
            done = true;
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Vision Truth"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: processing != true
                    ? Expanded(
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              child: Image.asset(
                                "assets/logo1.png",
                                height: height / 3,
                              ),
                              alignment: Alignment.topCenter,
                            ),
                            Text(
                              " ",
                              style: TextStyle(fontSize: height / 50),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: width,
                                child: GridView.extent(
                                  maxCrossAxisExtent: width / 2,
                                  semanticChildCount: 2,
                                  children: <Widget>[
                                    Card(
                                      elevation: 6,
                                      margin: EdgeInsets.all(8),
                                      child: InkWell(
                                        onTap: () {
                                          setState(
                                            () {
                                              people = false;
                                            },
                                          );
                                          get_image();
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(
                                              Icons.photo,
                                              size: width / 8,
                                              color: Colors.grey[800],
                                            ),
                                            Text(
                                              "Image without Faces",
                                              style: TextStyle(fontSize: 24),
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Card(
                                      margin: EdgeInsets.all(8),
                                      elevation: 6,
                                      child: InkWell(
                                        onTap: () {
                                          setState(
                                            () {
                                              people = true;
                                            },
                                          );
                                          get_image();
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(
                                              Icons.people,
                                              size: width / 8,
                                              color: Colors.grey[800],
                                            ),
                                            Text(
                                              "Image with Faces",
                                              style: TextStyle(fontSize: 24),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text(""),
              ),
              Container(
                child: processing == true
                    ? Expanded(
                        child: Column(
                          children: [
                            Center(
                              child: Image.file(
                                fileimage,
                                height: height / 3,
                              ),
                            ),
                            Text(" "),
                            done != true
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Text(
                                    result,
                                    style: TextStyle(fontSize: 17),
                                  ),
                          ],
                        ),
                      )
                    : Text(""),
              )
            ],
          ),
        ),
      ),
    );
  }
}

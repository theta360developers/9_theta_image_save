import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MaterialButton(
            onPressed: () async {
              var url = Uri.parse('http://192.168.1.1/osc/commands/execute');
              var header = {'Content-Type': 'application/json;charset=utf-8'};
              var bodyMap = {
                'name': 'camera.listFiles',
                'parameters': {
                  'fileType': 'image',
                  'startPosition': 0,
                  'entryCount': 1,
                  'maxThumbSize': 0,
                  '_detail': true,
                }
              };
              var bodyJson = jsonEncode(bodyMap);
              var response =
                  await http.post(url, headers: header, body: bodyJson);
              var fileUrl =
                  jsonDecode(response.body)['results']['entries'][0]['fileUrl'];

              await GallerySaver.saveImage(fileUrl);
            },
            color: Color.fromARGB(255, 126, 183, 228),
            child: Text("Camera Image"),
          ),
          MaterialButton(
            onPressed: () async {
              var url = Uri.parse('http://192.168.1.1/osc/commands/execute');
              var header = {'Content-Type': 'application/json;charset=utf-8'};
              var bodyMap = {
                'name': 'camera.listFiles',
                'parameters': {
                  'fileType': 'video',
                  'startPosition': 0,
                  'entryCount': 1,
                  'maxThumbSize': 0,
                  '_detail': true,
                }
              };
              var bodyJson = jsonEncode(bodyMap);
              var response =
                  await http.post(url, headers: header, body: bodyJson);
              var fileUrl =
                  jsonDecode(response.body)['results']['entries'][0]['fileUrl'];

              await GallerySaver.saveVideo(fileUrl);
            },
            color: Color.fromARGB(255, 126, 183, 228),
            child: Text("Camera Video"),
          ),
        ],
      ),
      MaterialButton(
        onPressed: () async {
          String url = 'https://picsum.photos/id/237/200/300';
          final tempDir = await getTemporaryDirectory();
          final path = '${tempDir.path}/myfile.jpg';
          print(path);
          await Dio().download(url, path);
          await GallerySaver.saveImage(path);
        },
        color: Color.fromARGB(255, 126, 183, 228),
        child: Text("test"),
      ),
    ]));
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({
    Key? key,
    required this.imageFile,
  }) : super(key: key);
  final File imageFile;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

// const String oldUri = 'https://us-central1-potatoe-disease-classification.cloudfunctions.net/predict';

class _ResultsPageState extends State<ResultsPage> {
  // Future fetchData() async {
  //   try {
  //     final request = MultipartRequest(
  //       'POST',
  //       Uri.parse("https://plant-disease-detector-pytorch.herokuapp.com/"),
  //     );

  //     request.files.add(
  //       MultipartFile.fromBytes(
  //           'image', File(widget.imageFile.path).readAsBytesSync(),
  //           filename: widget.imageFile.path),
  //     );
  //     final response = await request.send();
  //     final results = await response.stream.bytesToString();
  //     Map finalResults = await jsonDecode(results);
  //     return finalResults;
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text(
  //               "There was an error finding the disease, try again later")),
  //     );
  //   }

  //   return "We did it";
  // }
  Future<dynamic> fetchData() async {
    final imageBytes = File(widget.imageFile.path).readAsBytesSync();
    String imageBase64 = base64Encode(imageBytes);
    final dio = Dio();
    try {
      final response = await dio
          .post("https://plant-disease-detector-pytorch.herokuapp.com/", data: {
        'image': imageBase64,
      });
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final h6 = Theme.of(context).textTheme.headline6;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Predictions"),
      ),
      body: FutureBuilder<dynamic>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final resultsData = snapshot.data;
            final String disease = resultsData['disease'];
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.file(
                    widget.imageFile,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Condition :",
                          style: h6,
                        ),
                        Text(
                          disease,
                          style: h6!.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 40),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(MediaQuery.of(context).size.width * 0.6, 45),
                        ),
                        label: const Text("Upload Another Image"),
                        icon: const Icon(Icons.upload_file),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            return Center(
              child: Text(
                "There was an error connecting to server",
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          }
        },
      ),
    );
  }
}

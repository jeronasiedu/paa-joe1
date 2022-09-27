import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease/card.dart';
import 'package:plant_disease/pages/results.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  // File? imageFile;
  Future<void> takePicture() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      if (!mounted) return;
      if (pickedFile != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ResultsPage(
              imageFile: File(pickedFile.path),
            ),
          ),
        );
      }
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("There was an error taking the picture"),
        ),
      );
    }
  }

  Future<void> pickPicture() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (!mounted) return;
      if (pickedFile != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ResultsPage(
              imageFile: File(pickedFile.path),
            ),
          ),
        );
      }
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("There was an error taking the picture"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plant Disease Detector',
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const MyCard(),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  takePicture();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width * 0.6, 45),
                ),
                label: const Text("Camera"),
                icon: const Icon(Icons.camera_alt),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  pickPicture();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width * 0.6, 45),
                ),
                label: const Text("Gallery"),
                icon: const Icon(Icons.photo_library),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'full_screen_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  /// Load saved image path from SharedPreferences
  Future<void> _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImagePath = prefs.getString("profile_image");

    if (savedImagePath != null && File(savedImagePath).existsSync()) {
      setState(() {
        _imageFile = File(savedImagePath);
        _imagePath = savedImagePath;
      });
    }
  }

  /// Save image path to SharedPreferences
  Future<void> _saveImage(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("profile_image", path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_imageFile != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImage(imageFile: _imageFile!),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                          image: _imageFile != null
                              ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                              : null,
                        ),
                        child: _imageFile == null
                            ? Icon(
                          Icons.person_2,
                          size: 80.0,
                          color: Colors.grey.shade800,
                        )
                            : null,
                      ),
                    ),

                    // Container(
                    //   width: 150,
                    //   height: 150,
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey.shade300,
                    //     shape: BoxShape.circle,
                    //     image: _imageFile != null
                    //         ? (DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover))
                    //         : null,
                    //   ),
                    //   child:
                    //   _imageFile == null
                    //       ? Icon(
                    //           Icons.person_2,
                    //           size: 80.0,
                    //           color: Colors.grey.shade800,
                    //         )
                    //       : null,
                    // ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _showSourceDialog,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 20.0,
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              TextField(
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                maxLines: 6,
                minLines: 3,
                decoration: InputDecoration(
                  labelText: "Bio",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 100.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage({required ImageSource imageSource}) async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(
              source: imageSource,
              imageQuality: 80,
              ///IT WILL IGNORE IN THE GALLERY SOURCE
              preferredCameraDevice: CameraDevice.front);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _imagePath = pickedFile.path;
        });
        _saveImage(pickedFile.path); // Save image path
      }
    } catch (ex) {
      ex.toString();
    }
  }

  Future _showSourceDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text("Select Image Source"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ///Camera
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(imageSource: ImageSource.camera,);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.camera_alt),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text("Camera"),
                        ],
                      ),
                    ),
                  ),

                  ///Gallery
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(imageSource: ImageSource.gallery,);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.photo_library),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text("Gallery"),
                        ],
                      ),
                    ),
                  ),
                  ///REMOVE
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _imageFile = null;
                        _imagePath = null;
                      });
                      _saveImage(""); // Remove image path
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.remove_circle_outline),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text("Remove"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

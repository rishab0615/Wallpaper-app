import 'package:flutter/material.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:motion_toast/motion_toast.dart';
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class Fullscreen extends StatefulWidget {
  final String imgUrl;

  Fullscreen({super.key, required this.imgUrl});

  @override
  State<Fullscreen> createState() => _FullscreenState();
}

class _FullscreenState extends State<Fullscreen> {

  Future<bool> requestStoragePermission() async {
    final status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      _showToast(
        icon: Icons.error,
        primaryColor: Colors.red,
        secondaryColor: Colors.blue,
        title: 'Permission Denied',
        description: 'Storage permission is required.',
      );
    }
    return status.isGranted;
  }

  void _showToast({
    required IconData icon,
    required Color primaryColor,
    required Color secondaryColor,
    required String title,
    required String description,
  }) {
    MotionToast(
      icon: icon,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      title: Text(title),
      description: Text(description),
      animationType: AnimationType.fromBottom,
      height: 70,
      width: 300,
    ).show(context);
  }

  Future<void> setWallpaper() async {
    try {
      final isSet = await AsyncWallpaper.setWallpaper(
        url: widget.imgUrl,
        wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
        goToHome: true,
      );

      _showToast(
        icon: Icons.check,
        primaryColor: Colors.white!,
        secondaryColor: Colors.blue,
        title: 'Success',
        description: isSet ? 'Wallpaper set successfully!' : 'Failed to set wallpaper.',
      );
    } catch (e) {
      _showToast(
        icon: Icons.error,
        primaryColor: Colors.white70,
        secondaryColor: Colors.red,
        title: 'Error',
        description: 'Failed to set wallpaper: $e',
      );
    }
  }

  Future<void> downloadWallpaper() async {
    if (!await requestStoragePermission()) return;

    try {
      final response = await Dio().get(
        widget.imgUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "downloaded_wallpaper",
      );

      _showToast(
        icon: Icons.check,
        primaryColor: Colors.white!,
        secondaryColor: Colors.blue,
        title: 'Image downloaded',
        description: 'Check your gallery!',
      );
    } catch (e) {
      _showToast(
        icon: Icons.error,
        primaryColor: Colors.red,
        secondaryColor: Colors.blue,
        title: 'Error',
        description: 'Failed to download image: $e',
      );
    }
  }

  Future<void> shareImage() async {
    if (!await requestStoragePermission()) return;

    try {
      final response = await Dio().get(
        widget.imgUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/shared_image.jpg';
      final file = File(filePath);
      await file.writeAsBytes(response.data);

      await Share.shareXFiles([XFile(filePath)], text: 'Check out this wallpaper!');
    } catch (e) {
      _showToast(
        icon: Icons.error,
        primaryColor: Colors.red,
        secondaryColor: Colors.blue,
        title: 'Error',
        description: 'Failed to share image: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: setWallpaper,
            child: Text("Set Wallpaper", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
          ElevatedButton(
            onPressed: shareImage,
            child: Text("Share", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
          ElevatedButton(
            onPressed: downloadWallpaper,
            child: Text("Download", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Hero(
        tag: widget.imgUrl,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imgUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
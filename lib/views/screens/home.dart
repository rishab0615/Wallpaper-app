import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaperapp/controller/apiOperation.dart';
import 'package:wallpaperapp/model/photosModell.dart';
import 'package:wallpaperapp/views/screens/fullscreen.dart';
import 'package:wallpaperapp/views/widgets/catblock.dart';
import 'package:wallpaperapp/views/widgets/customappbar.dart';
import 'package:wallpaperapp/views/widgets/searchbar.dart';
import '../../model/categoryModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PhotosModel> trendinglist = [];
  List<CategoryModel> CatModList = [];
  int page = 1;
  bool isLoading = true;
  bool isLoadingPics = false;
  final ScrollController _scrollController = ScrollController();
  bool hasStoragePermission = false;

  Future<void> requestPermissions() async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;

    if (build.version.sdkInt >= 30) {
      var status = await Permission.manageExternalStorage.request();
      setState(() {
        hasStoragePermission = status.isGranted;
      });
    } else {
      var status = await Permission.storage.request();
      setState(() {
        hasStoragePermission = status.isGranted;
      });
    }

    if (!hasStoragePermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Storage permission is required to download or share images.'),
        ),
      );
    }
  }

  Future<void> getCatDetails() async {
    try {
      CatModList = await ApiOperations.getCategoriesList();
      setState(() {
        CatModList = CatModList;
      });
    } catch (e) {
      print("Error fetching category details: $e");
    }
  }

  Future<void> getTrendingWallpapers() async {
    try {
      trendinglist = await ApiOperations.getTrendingOperations();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching trending wallpapers: $e");
    }
  }

  Future<void> loadMoreWallpapers() async {
    if (isLoadingPics) return; // Prevent multiple requests

    setState(() {
      isLoadingPics = true; // Start loading more pictures
      page++;
    });

    try {
      List<PhotosModel> moreWallpapers = await ApiOperations.loadTrending(page);
      setState(() {
        trendinglist.addAll(moreWallpapers); // Append new wallpapers
        isLoadingPics = false; // Done loading more
      });
    } catch (e) {
      print("Error fetching more wallpapers: $e");
      setState(() {
        isLoadingPics = false; // Ensure loading state is reset on error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
    getCatDetails();
    getTrendingWallpapers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent &&
          !isLoadingPics) {
        loadMoreWallpapers();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Customappbar(word1: "Wallpaper", word2: " world"),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Customsearchbar(),
            Container(

              margin: EdgeInsets.symmetric(vertical: 20),
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: CatModList.length,
                itemBuilder: (context, index) => Catblock(
                  categoryImgSrc: CatModList[index].catImgUrl,
                  categoryName: CatModList[index].catName,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 15),
                child: GridView.builder(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 350,
                  ),
                  itemCount: trendinglist.length + 1,
                  itemBuilder: (context, index) {
                    if (index == trendinglist.length) {
                      return isLoadingPics
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(); // Load more spinner at the bottom
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Fullscreen(
                              imgUrl: trendinglist[index].imgsrc,
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: trendinglist[index].imgsrc,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade300,
                          ),
                          height: 400,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              trendinglist[index].imgsrc,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
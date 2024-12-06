
import 'package:flutter/material.dart';
import 'package:wallpaperapp/controller/apiOperation.dart';
import 'package:wallpaperapp/views/screens/fullscreen.dart';
import 'package:wallpaperapp/views/widgets/catblock.dart';
import 'package:wallpaperapp/views/widgets/customappbar.dart';
import 'package:wallpaperapp/views/widgets/searchbar.dart';

import '../../model/photosModell.dart';

class CategoryScreen extends StatefulWidget {
  String catImgUrl;
  String catName;

  CategoryScreen({super.key, required this.catImgUrl, required this.catName});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<PhotosModel> categoryResults = [];
  bool isLoading = true;
  int page = 1;
  bool isLoadingPics = false;
  final ScrollController _scrollController = ScrollController();

  GetCatRelWall() async {
    categoryResults = await ApiOperations.searchWallpapers(widget.catName);

    setState(() {
      isLoading = false;
    });
  }
  Future<void> loadMoreWallpapers() async {
    if (isLoadingPics) return; // Prevent multiple requests

    setState(() {
      isLoadingPics = true; // Start loading more pictures
      page++;
    });

    try {
      List<PhotosModel> moreWallpapers = await ApiOperations.loadCat(page,widget.catName);
      setState(() {
        categoryResults.addAll(moreWallpapers); // Append new wallpapers
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
    GetCatRelWall();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent &&
          !isLoadingPics) {
        print("00000000000000000000000000000000000000000000000000000000000000000000000000000");
        loadMoreWallpapers();
      }
    });
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
          child: CircularProgressIndicator(
            color: Colors.blue,
          ))
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(5)),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      widget.catImgUrl,
                      height: 150.0,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Container(
                    height: 150.0,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black45,
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Category",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.catName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 350),
                itemCount: categoryResults.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Fullscreen(
                              imgUrl: categoryResults[index].imgsrc),
                        ));
                  },
                  child: Hero(
                    tag: categoryResults[index].imgsrc,
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
                          categoryResults[index].imgsrc,
                          fit: BoxFit.cover,
                          loadingBuilder:
                              (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child; // Image fully loaded
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                  value: loadingProgress
                                      .expectedTotalBytes !=
                                      null
                                      ? loadingProgress
                                      .cumulativeBytesLoaded /
                                      loadingProgress
                                          .expectedTotalBytes!
                                      : null,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:wallpaperapp/controller/apiOperation.dart';
import 'package:wallpaperapp/model/photosModell.dart';
import 'package:wallpaperapp/views/screens/fullscreen.dart';
import 'package:wallpaperapp/views/widgets/customappbar.dart';
import 'package:wallpaperapp/views/widgets/searchbar.dart';

class SearchScreen extends StatefulWidget {
  String query;
  SearchScreen({super.key, required this.query});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = true;
  List<PhotosModel> searchResults = [];

  @override
  void initState() {
    getSearchResults();
    super.initState();
  }

  getSearchResults() async {
    searchResults = await ApiOperations.searchWallpapers(widget.query);
    setState(() {
      isLoading = false;
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
        child: CircularProgressIndicator(color: Colors.blue),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Customsearchbar(),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20, bottom: 15),
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 350,
                  ),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Fullscreen(
                            imgUrl: searchResults[index].imgsrc,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: searchResults[index].imgsrc,
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
                            searchResults[index].imgsrc,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child,
                                loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
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
            ),
          ],
        ),
      ),
    );
  }
}

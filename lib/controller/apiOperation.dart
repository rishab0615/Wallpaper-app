
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:wallpaperapp/model/photosModell.dart';
import '../model/categoryModel.dart';

class ApiOperations {                                              /// Master class


  ///---All declaration for variables
  static List<CategoryModel> cateogryModelList = [];
  static List<PhotosModel> trendingWallpapers = [];
  static List<PhotosModel> searchWallpaperList = [];
  static String ApiKey = "gUvDcPbAuR5DFQdZaa3x2q29yBXcOxPLK3UD7d8z1Y6whqrTLuDaJuUG";   //api key of pixel website
  static String baseUrl = "https://api.pexels.com/v1/";  //base url

  ///---All methods/opeations of api

  //Home page operations
  static Future<List<PhotosModel>> getTrendingOperations() async {
    trendingWallpapers.clear(); // Clear previous data before fetching new
    try {
      var response = await http.get(
        Uri.parse("${baseUrl}curated?per_page=30"),
        headers: {"Authorization": ApiKey},
      );

      if (response.statusCode == 200) {
        Map result = jsonDecode(response.body);
        List photos = result["photos"];

        photos.forEach((element) {
          trendingWallpapers.add(PhotosModel.fromApiToApp(element));
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to fetch trending wallpapers: $e");
    }

    return trendingWallpapers;
  }

  //-------------------//
  static loadTrending(int page)async{
    String url='${baseUrl}curated?per_page=30&page=${page.toString()}';
    var response= await http.get(Uri.parse(url),
        headers: {'Authorization':ApiKey});

    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      List photos = result["photos"];

      photos.forEach((element) {
        trendingWallpapers.add(PhotosModel.fromApiToApp(element));
      });
    } else {
      print("Error: ${response.statusCode}");
    }
    return trendingWallpapers;
  }


//---Search and category section
  static Future<List<PhotosModel>> searchWallpapers(String query) async {
    searchWallpaperList.clear(); // Clear previous data before fetching new

    try {
      var response = await http.get(
        Uri.parse("${baseUrl}search?query=${query}&per_page=30&page=1"),
        headers: {"Authorization": ApiKey},
      );

      if (response.statusCode == 200) {
        Map result = jsonDecode(response.body);
        List photos = result["photos"];

        photos.forEach((element) {
          searchWallpaperList.add(PhotosModel.fromApiToApp(element));
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to search wallpapers: $e");
    }

    return searchWallpaperList;
  }static Future<List<PhotosModel>> loadCat(int page,String query) async {
    searchWallpaperList.clear(); // Clear previous data before fetching new

    try {
      var response = await http.get(
        Uri.parse("${baseUrl}search?query=${query}&per_page=30&page=${page.toString()}"),
        headers: {"Authorization": ApiKey},
      );

      if (response.statusCode == 200) {
        Map result = jsonDecode(response.body);
        List photos = result["photos"];

        photos.forEach((element) {
          searchWallpaperList.add(PhotosModel.fromApiToApp(element));
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to search wallpapers: $e");
    }

    return searchWallpaperList;
  }



  ///------change done--//
  ///---CategoryTab of home page---api operations
  static Future<List<CategoryModel>> getCategoriesList() async {
    List<String> categoryNames = ["Cars", "Nature", "Bikes", "Street", "City", "Flowers"];
    cateogryModelList.clear(); // Clear previous data before fetching new
    final _random = Random();

    for (String catName in categoryNames) {
      List<PhotosModel> photos = await searchWallpapers(catName);
      if (photos.isNotEmpty) {
        PhotosModel photoModel = photos[_random.nextInt(photos.length)];
        cateogryModelList.add(CategoryModel(catImgUrl: photoModel.imgsrc, catName: catName));
        print("Category: $catName, Image: ${photoModel.imgsrc}");
      }
    }

    return cateogryModelList;
  }
}

import 'package:flutter/material.dart';
import 'package:wallpaperapp/views/screens/category.dart';

class Catblock extends StatelessWidget {
  String categoryName;
  String categoryImgSrc;

  Catblock({super.key,required this.categoryImgSrc,required this.categoryName});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(catImgUrl: categoryImgSrc,catName: categoryName),));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        // color: Colors.grey,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                  height: 50,
                  fit: BoxFit.cover,
                  width: 100,
                  categoryImgSrc),
            ),
            Container(

              height: 50,
              width: 100,
              child: Center(
                child: Text(
                  categoryName,
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
                ),
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade300),
                  color: Colors.black26, borderRadius: BorderRadius.circular(15)),
            ),


          ],
        ),
      ),
    );
  }
}
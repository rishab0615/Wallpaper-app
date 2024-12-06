
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:motion_toast/motion_toast.dart';
import 'package:wallpaperapp/views/screens/search.dart';
import 'package:wallpaperapp/views/screens/search.dart';

class Customsearchbar extends StatefulWidget {
  Customsearchbar({super.key});

  @override
  State<Customsearchbar> createState() => _CustomsearchbarState();
}

class _CustomsearchbarState extends State<Customsearchbar> {
  bool isEmpty=false;

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus the text field when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color:Colors.blue),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                focusNode: FocusNode(canRequestFocus: false,),
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search ...",
                  hintStyle:
                  TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
                  // fillColor: Colors.blue,
                  // filled: true,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
                height: 38,
                width: 38,
                decoration:
                BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                child: Center(
                    child: IconButton(
                        onPressed: () {
                          if(_searchController.text.trim()==""){
                            setState(() {
                              MotionToast(
                                icon:  Icons.close,
                                primaryColor:  Colors.white70!,
                                secondaryColor:  Colors.red,
                                // opacity:  0.4,
                                title:  Text('Empty search field'),
                                description:  Text('Write something to search'),
                                animationType: AnimationType.fromLeft,

                                // position: MotionToastPosition.center,
                                //           animationDuration: Durations.extralong4,
                                //                              position: MotionToastPosition.center

                                toastDuration: Duration(seconds: 3),

                                // position:  MotionToastPosition.center,
                                height:  60,
                                width:  300,
                              ).show(context);
                            });
                          }
                          else{
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SearchScreen(query: _searchController.text),
                                ));
                          }

                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ))))
          ],
        ),
      ),
    );
  }
}

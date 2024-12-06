class PhotosModel{
  String imgsrc;
  String phname;

  PhotosModel({
    required this.imgsrc,
    required this.phname
  });



  static fromApiToApp(Map<String,dynamic> photoMap){
    return PhotosModel(imgsrc: photoMap["src"]["portrait"], phname: photoMap["photographer"]);
  }
}
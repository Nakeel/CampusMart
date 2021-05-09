import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewer extends StatelessWidget {
  final List<String> imageList;
  final String itemtitle;

  ImageViewer({Key key, @required this.imageList, this.itemtitle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemtitle),
      ),
      // add this body tag with container and photoview widget
      body: PhotoViewGallery.builder(
        
        itemCount: imageList.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageList[index]),
            // Image(
            //           image: NetworkImage(
            //               'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
            //           width: 240,
            //           height: 240,
            //           fit: BoxFit.cover,
            //         ),
            // AssetImage(imageList[index]),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
        loadingChild: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

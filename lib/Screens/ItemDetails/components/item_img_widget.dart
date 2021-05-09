import 'dart:async';

import 'package:campus_mart/constants.dart';
import 'package:campus_mart/utils/image_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ItemImgWidget extends StatefulWidget {
  const ItemImgWidget({
    Key key,
    this.itemImgList,
  }) : super(key: key);

  final GoodsAd itemImgList;

  @override
  _ItemImgWidgetState createState() => _ItemImgWidgetState();

}

class _ItemImgWidgetState extends State<ItemImgWidget> {
  int _selectedImgIndex = 0;
  bool _isLoading  ;

  @override
  void initState() {
    _isLoading  = true;
    Timer(Duration(milliseconds: 100), (){
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('GoodsImag' + widget.itemImgList.itemImgList.length.toString());
    print('GoodsImage' + widget.itemImgList.itemImgList[0]);
    return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Center(
              child: CarouselSlider(
                autoPlay: false,
                reverse: false,
                aspectRatio: 16 / 14,
                initialPage: 1,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                onPageChanged: (index) {
                  setState(() {
                    _selectedImgIndex = index;
                  });
                },
                items: widget.itemImgList.itemImgList
                    .asMap()
                    .entries
                    .map(
                      (e) => ItemImage(
                        isLoading: _isLoading,
                        imageUrl: widget.itemImgList.itemImgList[e.key],
                        imageHash: widget.itemImgList.itemImgListHash[e.key],
                        tag: widget.itemImgList.itemTitle +
                            widget.itemImgList.datePosted,
                      ),
                    )
                    .toList(),
              ),
            ),
            Positioned(
              bottom: 15,
              left: MediaQuery.of(context).size.width * 0.5,
              child: Center(
                child: Container(
                  child: AnimatedSmoothIndicator(
                    activeIndex: _selectedImgIndex,
                    count: widget.itemImgList.itemImgList.length,
                    // count: 2,
                    effect: ExpandingDotsEffect(
                      dotHeight: 5,
                      radius: 10,
                      dotWidth: 5,
                      activeDotColor: kPrimaryColor,
                      dotColor: kPrimaryLightColor,
                      expansionFactor: 4,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: Positioned(
                  top: 2,
                  right: 2,
                  child: IconButton(
                      icon: Icon(Icons.zoom_out_map,
                          size: 30, color: kPrimaryColor),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageViewer(
                                      imageList: widget.itemImgList.itemImgList,
                                      itemtitle: widget.itemImgList.itemTitle,
                                    )));
                      })),
            ),
          ],
        ));
  }
}

class ItemImage extends StatelessWidget {
  const ItemImage({
    Key key,
    this.imageUrl,
    this.tag,

    this.imageHash, this.isLoading,
  }) : super(key: key);
  final String imageUrl;
  final String imageHash;
  final String tag;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    print('ImageItem :' + imageUrl);
    return Hero(
      tag: tag,
      transitionOnUserGestures: true,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: isLoading ? CircularProgressIndicator(

          ) :
          Image(
              image: NetworkImage(imageUrl),
              // width: 110.0,
              // height: 170,
              fit: BoxFit.cover,
            ),
          //     Image.network(imageUrl,
          //       errorBuilder:
          //       (BuildContext context, Object exception, StackTrace stackTrace) {
          //       return Text('error');
          //       })
          // BlurHash(
          //   color: Colors.blueGrey[100],
          //   hash: imageHash,
          //   image: imageUrl,
          //   imageFit: BoxFit.cover,
          //   duration: Duration(seconds: 5),
          //   curve: Curves.easeOut,
          // ),
        
        ),
      ),
    );
  }
}

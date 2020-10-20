import 'package:campus_mart/constants.dart';
import 'package:campus_mart/utils/image_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:campus_mart/models/goods_ad_data.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'image_and_icons.dart';

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
  
  @override
  Widget build(BuildContext context) {
    print('GoodsImag' + widget.itemImgList.itemImgList.length.toString());
    return Stack(
      children: [
        CarouselSlider(
          aspectRatio: 7 / 16,
          autoPlay: true,
          reverse: true,
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
                (e) => ItemImage(imageUrl: widget.itemImgList.itemImgList[e.key], tag: widget.itemImgList.itemTitle + widget.itemImgList.datePosted,),
              )
              .toList(),
        ),
        Positioned(
          bottom: 15,
          left: 80,
          child: Container(
            child: AnimatedSmoothIndicator(
              activeIndex: _selectedImgIndex,
              count: widget.itemImgList.itemImgList.length,
              // count: 2,
              effect: ExpandingDotsEffect(
                dotHeight: 10,
                radius: 20,
                dotWidth: 10,
                activeDotColor: kPrimaryColor,
                dotColor: kPrimaryLightColor,
                expansionFactor: 4,
              ),
            ),
          ),
        ),
        Positioned(
            top: 2,
            right: 2,
            child: IconButton(
                icon: Icon(Icons.zoom_out_map, size: 30, color: kPrimaryColor),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageViewer(
                                imageList: widget.itemImgList.itemImgList,
                                itemtitle: widget.itemImgList.itemTitle,
                              )));
                })),
      ],
    );
  }
}

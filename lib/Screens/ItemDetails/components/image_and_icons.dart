import 'package:campus_mart/Screens/ItemDetails/components/color_and_size.dart';
import 'package:campus_mart/Screens/ItemDetails/components/description_text.dart';
import 'package:campus_mart/Screens/ItemDetails/components/icon_card.dart';
import 'package:campus_mart/Screens/ItemDetails/components/seller_info.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'item_img_widget.dart';

class ImageAndIcons extends StatefulWidget {
  const ImageAndIcons({
    Key key,
    @required this.size,
    this.goodsAd,
  }) : super(key: key);

  final Size size;
  final GoodsAd goodsAd;

  @override
  _ImageAndIconsState createState() => _ImageAndIconsState();
}

class _ImageAndIconsState extends State<ImageAndIcons>
    with SingleTickerProviderStateMixin {
  // List<String> _itemImgList = widget.goodsAd.itemImgList;

  List<Container> iconCards = [];
  Widget _myAnimatedWidget;
  int currentPos = 0;
  bool isActive = false;
  final controller = PageController(viewportFraction: 0.7);

  int _selectedIconIndex = 0;
  int _selectedImgIndex = 0;

  List<IconData> _iconList = [
    Icons.access_time,
    Icons.account_balance,
    Icons.account_balance_wallet,
  ];

  @override
  void initState() {
    _myAnimatedWidget = ItemImgWidget(itemImgList: widget.goodsAd);
    super.initState();
  }

  Widget _switchWidget(index) {
    if (index == 0) {
      return ItemImgWidget(itemImgList: widget.goodsAd);
    } else if (index == 1) {
      return DescriptionText(
        goodsAd: widget.goodsAd,
      );
    } else if (index == 2) {
      return SellerInfo(
        goodAd: widget.goodsAd,
      );
    }
  }

  Widget _buildIcon(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIconIndex = index;
          _myAnimatedWidget = _switchWidget(index);
        });
      },
      child: Container(
        height: 63.0,
        width: 63.0,
        decoration: BoxDecoration(
            color: _selectedIconIndex == index
                ? kPrimaryLightColor
                : Color(0xFFE7EBEE),
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 22,
                  color: kPrimaryColor.withOpacity(0.22)),
              BoxShadow(
                  offset: Offset(-15, -15),
                  blurRadius: 20,
                  color: Colors.white),
            ]),
        child: Icon(
          _iconList[index],
          size: 25.0,
          color:
              _selectedIconIndex == index ? kPrimaryColor : Color(0xFFB4C1C4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kDefaultPadding * 3),
      child: SizedBox(
        height: widget.size.height * 0.7,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        icon: SvgPicture.asset("assets/icons/back_arrow.svg"),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                  // Spacer(
                  //   flex: 50,
                  // ),
                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _iconList
                          .asMap()
                          .entries
                          .map(
                            (e) => _buildIcon(e.key),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: widget.size.height * 0.7,
                width: widget.size.width * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(63),
                  ),

                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 60,
                      color: kPrimaryColor.withOpacity(0.29),
                    )
                  ],
                  //   image: DecorationImage(
                  //       image: AssetImage("assets/images/img.png"),
                  //       fit: BoxFit.cover,
                  //       alignment: Alignment.centerLeft),
                ),
                // child: SellerInfo()
                // // DescriptionText(),

                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  //Enable this for ScaleTransition
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  //Enable this for RotationTransition
                  // transitionBuilder: (Widget child, Animation<double> animation) {
                  //   return RotationTransition(
                  //     child: child,
                  //     turns: animation,
                  //   );
                  // },
                  child: _myAnimatedWidget,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DescriptionText()

class ItemImage extends StatelessWidget {
  const ItemImage({
    Key key,
    this.imageUrl,
    this.tag,
  }) : super(key: key);
  final String imageUrl;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      transitionOnUserGestures: true,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40)),
          child: Image(
            image: NetworkImage(imageUrl),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

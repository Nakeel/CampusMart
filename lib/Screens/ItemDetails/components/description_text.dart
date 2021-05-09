import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:flutter/material.dart';

class DescriptionText extends StatefulWidget {
  const DescriptionText({
    Key key,
    @required this.goodsAd,
  }) : super(key: key);

  final GoodsAd goodsAd;

  @override
  _DescriptionTextState createState() => _DescriptionTextState();
}

class _DescriptionTextState extends State<DescriptionText> {
  Widget _featureItemChips(String feature) {
    return Container(
      margin: EdgeInsets.all(3.0),
      child: Chip(
        label: Text(
          feature,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: kPrimaryColor),
        ),
        // avatar: CircleAvatar(
        //   backgroundColor: kPrimaryLightColor,
        //   child:Text(feature[0].toUpperCase(),)
        // ),
        labelPadding: EdgeInsets.all(2.0),
        elevation: 1.0,
        shadowColor: Colors.grey,
        padding: EdgeInsets.all(6.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // var listFeatures = widget.goodsAd.itemFeatures;
    // print('listFeatures' + listFeatures[0]);
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding, horizontal: kDefaultPadding),
      child: Column(
        children: [
          Text(
            'Item Detail',
            style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 26, color: Colors.black),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            widget.goodsAd.itemDesc,
            style: TextStyle(height: 1.5),
          ),
          SizedBox(
            height: 30,
          ),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: widget.goodsAd.itemFeatures
                .asMap()
                .entries
                .map(
                  (e) => _featureItemChips(e.value),
                )
                .toList(),
          //   // [
          //   //   _featureItemChips('Second hand'),
          //   //   _featureItemChips('London Used'),
          //   //   _featureItemChips('hand'),
          //   //   _featureItemChips('Second hand'),
          //   // ],
          )
        ],
      ),
    );
  }
}

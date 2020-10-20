import 'package:campus_mart/Screens/Home/components/category_list.dart';
import 'package:campus_mart/Screens/Home/components/featured_items.dart';
import 'package:campus_mart/Screens/Home/components/header_with_searchbox.dart';
import 'package:campus_mart/Screens/Home/components/recommended_Item_card.dart';
import 'package:campus_mart/Screens/Home/components/recommended_items.dart';
import 'package:campus_mart/Screens/Home/components/title_with_more_btn.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'item_category.dart';

class FavoriteMain extends StatefulWidget {
  static const TextStyle userNameStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<FavoriteMain> {
  String _username;
  int _count = 3;
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUserInfo>(context);

    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
              child: Text(
                'You have $_count items in your favourite list',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
            ),
            ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Dismissible(
                // Specify the direction to swipe and delete
                direction: DismissDirection.endToStart,
                key: Key(item),
                onDismissed: (direction) {
                  // Removes that item the list on swipwe
                  setState(() {
                    items.removeAt(index);
                  });
                  },
                background: Container(color: Colors.red),
                child: FavouriteItems(),
              );
            },
          ),

           
            
          ],
        ),
      ),
    );
  }
}

class FavouriteItems extends StatelessWidget {
  const FavouriteItems({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Text _buildRatingStars(int rating) {
      String stars = '';
      for (int i = 0; i < rating; i++) {
        stars += '⭐ ';
      }
      stars.trim;
      return Text(stars);
    }

    return Stack(children: [
      Container(
        margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
        height: 150.0,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    child: Text(
                      'Walking Tour in Street of Mapo in City Of Ibadan',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '\$4000',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Negotiable',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                'Electronics',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              _buildRatingStars(5),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    width: 70.0,
                    decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    alignment: Alignment.center,
                    child: Text('Delete'),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    width: 70.0,
                    decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    alignment: Alignment.center,
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Positioned(
        left: 20.0,
        top: 15.0,
        bottom: 15.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            "assets/images/image_1.png",
            fit: BoxFit.cover,
            width: 110.0,
          ),
        ),
      )
    ]);
  }
}

// @dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'debouncer.dart';


class SearchableItemWidget extends StatefulWidget {
  final List<String> items;

  const SearchableItemWidget({Key key, this.items}) : super(key: key);
  @override
  SearchableItemWidgetState createState() => new SearchableItemWidgetState();
}

class SearchableItemWidgetState extends State<SearchableItemWidget>  {

  List<String> itemsList = [];
  List<String> filteredItemsList = [];
  bool hasRun = false;

  TextEditingController textEditingController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 400);


  @override
  void dispose() {
    super.dispose();
  }

  processCountryList(List<String> countryList){
    try{
      if(countryList!=null){
        itemsList = countryList.toSet().toList();
        if(!hasRun) {
          hasRun = true;
          filteredItemsList = itemsList;
        }
      }else{
        itemsList = [];
        filteredItemsList = [];
      }
    }catch(e){
      itemsList = [];
      filteredItemsList = [];
      print('countryError $e');
    }
  }

  searchList(String val){
    setState(() {
      if(val.isNotEmpty){
        print('country $val');
        filteredItemsList = itemsList.where((element) => element.toLowerCase().contains(val.toLowerCase())).toList();
      }else {
        filteredItemsList = itemsList.toList();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    processCountryList(widget.items);
      return Scaffold(
        backgroundColor: Colors.black.withOpacity(.4),
        body: Stack(
          children: [
            Positioned(
                bottom: 0,
                child: Container(
                  width: size.width,
                  height: size.height * .65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        width: size.width,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child:
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 2,),
                            Center(
                              child:
                              Text('Select Item',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15,),
                      Divider(height: 1, thickness: 1.5,),
                      SizedBox(height: 10,),


                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                              isDense: true,
                              fillColor: Colors.transparent,
                              filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                textEditingController.text.isNotEmpty ? Icons.close : Icons.search,
                                color: textEditingController.text.isNotEmpty ? Theme.of(context).primaryColor.withOpacity(.7) :  Colors.green,
                              ),
                              onPressed: () {
                                if(textEditingController.text.isNotEmpty) {
                                  setState(() {
                                    textEditingController.text = '';
                                  });
                                }
                              },
                            ),
                            labelText: 'Search',
                          ),
                          onChanged: (val) {
                            _debouncer.run(() {
                              searchList(val);
                            });
                          },
                          controller: textEditingController,
                          keyboardType: TextInputType.text,

                        ),
                      ),
                      SizedBox(height: 10,),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            child: filteredItemsList.isNotEmpty ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: filteredItemsList.asMap().entries.map((e) {

                                  String item = e.value;
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          Navigator.of(context).pop(e.value);
                                        },
                                        child: Padding(
                                          padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                          child: Text(
                                            '${toBeginningOfSentenceCase(item)}' ,
                                            style:  TextStyle( fontSize: 17),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.black.withOpacity(.5),
                                        thickness: 0.3,
                                      )
                                    ],
                                  );
                                }).toList()

                            ) :
                            Container(
                              width: size.width ,
                              height: size.height * .3,
                              child: Center(
                                child: Text(
                                  'No country found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                ))
          ],
        ),
      );

  }
}

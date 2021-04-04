import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/configs/constants.dart';
import 'package:listar_flutter_pro/configs/routes.dart';
import 'package:listar_flutter_pro/models/carrage.dart';
import 'package:listar_flutter_pro/providers/edit_list_provider.dart';
import 'package:listar_flutter_pro/screens/product_detail/product_detail.dart';
import 'package:listar_flutter_pro/widgets/app_navbar.dart';
import 'package:listar_flutter_pro/widgets/app_product_item.dart';
import 'package:listar_flutter_pro/widgets/display_list_item.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DisplayListing extends StatefulWidget {
  static const classname = "/DisplayListing";

  @override
  _DisplayListingState createState() => _DisplayListingState();
}

class _DisplayListingState extends State<DisplayListing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<EditListProvider>(builder: (context, value, child) {
        if (value.currunt_state == appstate.loading ||
            value.currunt_state == appstate.defaultstate)
          return (Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ));
        if (value.currunt_state == appstate.laoding_complete)
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: value.refreshController,
            /*  onRefresh: _onRefresh,*/
            onLoading: value.onLoading,
            onRefresh: (){
              value.onRefresh();
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Card(
                    child: DisplayListItem(
                      carrage: Carrage(dataListModel:value.ls[index] ),
                      imageUrl: "${value.ls[index].image.thumb.url}",
                      active: true,
                      address: "${value.ls[index].address}",
                      status:
                          "${value.ls[index].status.index == 1 ? "Found" : "Not Found"}",
                      rate: value.ls[index].ratingCount.toDouble(),
                      title: "${value.ls[index].postTitle}",
                      phone_number: "${value.ls[index].phone}",
                    ),
                  ),
                );
              },
              itemCount: value.ls.length,
            ),
          );
      }),
    );
  }

  @override
  void initState() {
    final provider = Provider.of<EditListProvider>(context, listen: false);
    provider.init();
  }
}
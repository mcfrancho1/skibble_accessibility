import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:skibble/services/change_data_notifiers/kitchens_data/kitchen_data.dart';

import '../../../models/kitchen_group.dart';
import '../../../models/skibble_user.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../services/firebase/database/kitchens_database.dart';
import '../../../shared/no_content_view.dart';
import '../../../utils/constants.dart';
import '../../../utils/current_theme.dart';
import '../../../utils/helper_methods.dart';

import '../kitchen_profile/kitchen_profile_page.dart';
import 'discover_page_kitchens_list_view.dart';
import 'kitchen_card.dart';
import 'kitchen_search_view.dart';

class KitchenViewMoreAndFilterView extends StatefulWidget {
  const KitchenViewMoreAndFilterView({Key? key, required this.kitchenGroup }) : super(key: key);


  final KitchenGroup kitchenGroup;
  @override
  State<KitchenViewMoreAndFilterView> createState() => _KitchenViewMoreAndFilterViewState();
}

class _KitchenViewMoreAndFilterViewState extends State<KitchenViewMoreAndFilterView> {

  Future? kitchensFuture;

  TextEditingController controller = TextEditingController();

  // String searchType = 'people';


  static const _pageSize = 20;

  final PagingController<int, SkibbleUser> _pagingController =
  PagingController(firstPageKey: 0);

  @override
  void initState() {
    // TODO: implement initState
    var user = Provider.of<AppData>(context, listen: false).skibbleUser!;

    var discoverPageKitchens = Provider
        .of<KitchensData>(context, listen: false)
        .discoverPageKitchens;

      _pagingController.addPageRequestListener((pageKey) {
        if (pageKey == 0) {
          // final nextPageKey = (pageKey + widget.kitchenGroup.kitchens.length).toInt();
          // _pagingController.appendPage(widget.kitchenGroup.kitchens, nextPageKey);
          // _pagingController.itemList = widget.kitchenGroup.kitchens;
          _pagingController.appendLastPage(widget.kitchenGroup.userKitchens);

          // _pagingController.nextPageKey = widget.kitchenGroup.kitchens.length ;
        }

        else {
          _fetchPage(pageKey);

          // exploreFuture = Future.value(exploreData);
        }

      });

      // exploreFuture = FeedDatabaseService().getUserExploreContents(currentUser.contentPreferences!, context);


    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      var currentUser = Provider
          .of<AppData>(context, listen: false)
          .skibbleUser;

      var currentUserLocation = Provider
          .of<AppData>(context, listen: false)
          .userCurrentLocation;

      var kitchensGroup = Provider.of<KitchensData>(context, listen: false).discoverPageKitchens.firstWhere((element) => element.groupTitle == widget.kitchenGroup.groupTitle);

      List<SkibbleUser> kitchens = [];
      if(widget.kitchenGroup.groupTitle == 'top rated') {
        kitchens = await KitchenDatabaseService().getNewTopRatedKitchensList(context, currentUserLocation!, kitchensGroup.userKitchens.last.userId!);

      }
      else {
        // chefs = await KitchenDatabaseService().getNewTopRatedKitchensList(context, currentUserLocation!, chefsGroup.kitchens.last.userId!);

      }


      final isLastPage = kitchens.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(kitchens);
      }

      else {
        final nextPageKey = (pageKey + kitchens.length).toInt();
        _pagingController.appendPage(kitchens, nextPageKey);

      }

    } catch (error) {
      _pagingController.error = error;
    }
  }


  @override
  Widget build(BuildContext context) {
    // var friendsList = Provider.of<AppData>(context).friendsList;
    // var friendRequestList = Provider.of<AppData>(context).friendRequestList;

    Size size = MediaQuery.of(context).size;
    var user = Provider.of<AppData>(context).skibbleUser!;

    return GestureDetector(
      onTap: () => HelperMethods().dismissKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 80,
          leadingWidth: 30,
          leading: BackButton(
            color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor: kDarkSecondaryColor,),
          backgroundColor: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme,
          title: Container(
            height: 40,
            // padding: EdgeInsets.all(10),

            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        KitchenSearchView(
                          groupTitle: widget.kitchenGroup.groupTitle,
                        )));
              },
              child: TextField(
                // onChanged: (value) => onSearch(value, user.userId!),
                controller: controller,
                decoration: InputDecoration(
                    filled: true,
                    enabled: false,
                    fillColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : Colors.grey.shade300,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade500,),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none
                    ),
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500
                    ),
                    hintText: "Find ${widget.kitchenGroup.groupTitle} kitchens here..."
                ),
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${widget.kitchenGroup.groupTitle.capitalizeFirst} kitchens',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),
              ),
            ),

            // SizedBox(height: 20,),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: RefreshIndicator(
                  onRefresh: (){
                    return Future.sync(() {
                      // Provider.of<FeedData>(context,listen: false).resetExploreFeed();
                      return _pagingController.refresh();
                    });
                  },
                  child: PagedGridView<int, SkibbleUser>(
                    showNewPageProgressIndicatorAsGridChild: true,
                    showNewPageErrorIndicatorAsGridChild: false,
                    showNoMoreItemsIndicatorAsGridChild: false,
                    shrinkWrap: true,
                    pagingController: _pagingController,
                    gridDelegate:

                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: size.width > 600 ? 1 / (0.6) :  1 / (1.4),

                      // [
                      //   QuiltedGridTile(1, 1),
                      //   QuiltedGridTile(1, 1),
                      //   QuiltedGridTile(1, 1),
                      //   // QuiltedGridTile(2, 1),
                      // ],
                    ),

                    // const SliverGridDelegateWithFixedCrossAxisCount(
                    //   childAspectRatio: 100 / 150,
                    //   crossAxisSpacing: 4,
                    //   mainAxisSpacing: 4,
                    //   crossAxisCount: 3,
                    // ),

                    builderDelegate: PagedChildBuilderDelegate<SkibbleUser>(
                        itemBuilder: (context, item, index) {
                          // print(item.feedPostType);
                          // print(index);
                          return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        KitchenProfilePage(
                                            skibbleUser: item)));
                              },
                              child: NewDiscoverPageKitchenCard(kitchenUser: item,));
                        },
                        firstPageProgressIndicatorBuilder: (context) {
                          return DiscoverPageListViewShimmer();
                        },
                        noItemsFoundIndicatorBuilder: (context) {
                          return NoContentView(message: 'No kitchens found');
                        }
                      // newPageProgressIndicatorBuilder: (context) {
                      //   return NewExplorePageShimmer();
                      // }
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  // onSearch(String pattern, String userId) async{
  //   if(pattern.length > 0) {
  //
  //     setState(() {
  //       kitchensFuture = TypeSenseSearch().searchKitchensByPattern(pattern);
  //     });
  //   }
  //   else {
  //     setState(() {
  //       kitchensFuture = null;
  //     });
  //   }
  // }

}

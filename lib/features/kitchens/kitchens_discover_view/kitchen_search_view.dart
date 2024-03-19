import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/place_suggestion.dart';

import '../../../models/skibble_user.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../services/typesense_search.dart';
import '../../../utils/constants.dart';
import '../../../utils/current_theme.dart';
import '../../../utils/helper_methods.dart';
import '../../chats/all_search_view.dart';
import '../kitchen_profile/kitchen_profile_page.dart';


class KitchenSearchView extends StatefulWidget {
  const KitchenSearchView({Key? key, required this.groupTitle }) : super(key: key);


  final String groupTitle;
  @override
  State<KitchenSearchView> createState() => _KitchenSearchViewState();
}

class _KitchenSearchViewState extends State<KitchenSearchView> with TickerProviderStateMixin {

  Future? kitchensFuture;

  TextEditingController controller = TextEditingController();

  // String searchType = 'people';

  @override
  void initState() {
    // TODO: implement initState
    var user = Provider.of<AppData>(context, listen: false).skibbleUser!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var friendsList = Provider.of<AppData>(context).friendsList;
    // var friendRequestList = Provider.of<AppData>(context).friendRequestList;

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

            child: TextField(
              onChanged: (value) => onSearch(value, user.userId!),
              controller: controller,
              decoration: InputDecoration(
                  filled: true,
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
                  hintText: "Search for ${widget.groupTitle} kitchens here..."
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: kitchensFuture,
                  builder: (context, snapshot) {
                    switch(snapshot.connectionState) {

                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Container(

                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if(snapshot.hasData) {

                          List<UserSuggestion> skibbleUsersList = snapshot.data as List<UserSuggestion>;


                          return skibbleUsersList.length > 0 ?
                          ListView.builder(
                              itemCount: skibbleUsersList.length,
                              itemBuilder: (context, index) {
                                var user =  SkibbleUser(
                                    userId:  skibbleUsersList[index].id,
                                    fullName: skibbleUsersList[index].title,
                                    userName: skibbleUsersList[index].subTitle,
                                    profileImageUrl: skibbleUsersList[index].imageUrl
                                );

                                return SuggestionCard(
                                  skibbleUserSuggestion: user,
                                  onTapSuggestion: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) =>

                                            KitchenProfileFuture(
                                                user:user)));
                                  },
                                );
                              })
                              : Center(child: Text("No Results Found", style: TextStyle(color: Colors.white),));
                        }
                        else {
                          return Container();
                        }
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

  onSearch(String pattern, String userId) async{
    if(pattern.length > 0) {

      setState(() {
        kitchensFuture = TypeSenseSearch().searchChefsByPattern(pattern);
      });
    }
    else {
      setState(() {
        kitchensFuture = null;
      });
    }
  }

}

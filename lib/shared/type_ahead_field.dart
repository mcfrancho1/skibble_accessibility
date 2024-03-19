import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:skibble/custom_icons/chef_icons_icons.dart';
import 'package:skibble/models/suggestion.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';

class CustomTypeAheadField extends StatefulWidget {
  const CustomTypeAheadField({Key? key,
    this.textFieldConfiguration,
    this.containerDecoration,
    this.containerMargin,
    this.isUserName = false,
    required this.onSuggestionSelected,
    required this.suggestionCallback,
  }) : super(key: key);

  // final Function(String)

  final TextFieldConfiguration? textFieldConfiguration;
  final BoxDecoration? containerDecoration;
  final EdgeInsetsGeometry? containerMargin;
  final Function(Suggestion suggestion) onSuggestionSelected;
  final bool isUserName;
  final FutureOr<Iterable<Suggestion>> Function(String pattern) suggestionCallback;

  @override
  _CustomTypeAheadFieldState createState() => _CustomTypeAheadFieldState();
}

class _CustomTypeAheadFieldState extends State<CustomTypeAheadField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.containerMargin != null ? widget.containerMargin : EdgeInsets.symmetric(horizontal: 20),
      decoration: widget.containerDecoration != null ? widget.containerDecoration : BoxDecoration(
        color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(13)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color:   CurrentTheme(context).isDarkMode ? kDarkSecondaryColor.withOpacity(.3) : Colors.grey.withOpacity(.3),
            blurRadius: 15,
            offset: Offset(5, 5),
          )
        ],
      ),

      child: TypeAheadField<Suggestion>(
        minCharsForSuggestions: 1,
        textFieldConfiguration: widget.textFieldConfiguration != null ? widget.textFieldConfiguration! : TextFieldConfiguration(
          // autofocus: true,
          // style: DefaultTextStyle.of(context).style.copyWith(
          //     fontStyle: FontStyle.italic
          // ),
          decoration: InputDecoration(
              hintText: 'Search ...',
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kContentColorLightTheme,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10)
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kPrimaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10)

              )
          ),
        ),
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
            color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
            borderRadius: BorderRadius.circular(10)
        ),

        suggestionsCallback: (pattern) => widget.suggestionCallback(pattern),
        loadingBuilder: (context) {
          return Container(
            // margin: EdgeInsets.symmetric(horizontal: 20),
            // padding: EdgeInsets.symmetric(vertical: 4),
            height: 60,
            child: SpinKitFadingCircle(
              color: kPrimaryColor,
              size: 40,
            ),
          );
        },
        itemBuilder: (context, suggestion) {
          return Column(
            children: [
              ListTile(
                leading: suggestion.type != 'user' ? null : Container(
                  height: 60,
                  width: 60,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  margin: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kPrimaryColor,
                      image: suggestion.isImage ?  suggestion.imageUrl != null ? DecorationImage(
                          image: CachedNetworkImageProvider(suggestion.imageUrl!),
                          fit: BoxFit.cover
                      ) : null : null
                  ),
                  child: !suggestion.isImage ?
                  suggestion.icon :
                  suggestion.imageUrl == null ? Icon(ChefIcons.chef_hat, color: kLightSecondaryColor,) : null,
                ) ,
                title: Text(suggestion.title, maxLines: 2, overflow: TextOverflow.ellipsis,),
                subtitle:suggestion.subTitle == null ? null: suggestion.subTitle!.trim().isNotEmpty ? Text(widget.isUserName ? "@${suggestion.subTitle}" : "${suggestion.subTitle}", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey),) : null,
              ),

              Divider()
            ],
          );
        },
        onSuggestionSelected: (suggestion) => widget.onSuggestionSelected(suggestion)
      ),
    );
  }
}

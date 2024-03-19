
import 'package:flutter/material.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';

import '../services/preferences/preferences.dart';

class OptionSwitch extends StatefulWidget {

  const OptionSwitch( {
    Key? key,
    required this.title,
    required this.icon,
    required this.id,
    this.defaultBool = false,
    this.subtitle,
    required this.onSwitched
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final IconData icon;
  final String id;
  final bool defaultBool;
  final ValueChanged<bool> onSwitched;

  @override
  _OptionSwitchState createState() => _OptionSwitchState();
}

class _OptionSwitchState extends State<OptionSwitch> {


  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
          widget.icon,
          color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      title: Text(
        widget.title,
        style: TextStyle(
            color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
            fontFamily: "Brand Bold"
        ),
      ),
      subtitle: widget.subtitle != null ?
      Text(
        widget.subtitle!,
        style: TextStyle(
          color: CurrentTheme(context).isDarkMode ? Colors.grey : Colors.black38,
          fontFamily: 'Brand Regular'
        )
      )
          : null,
      trailing: Switch(
        value: widget.defaultBool,
        onChanged: widget.onSwitched,
        activeTrackColor: kPrimaryColor.withAlpha(90),
        activeColor: kPrimaryColor,
        inactiveTrackColor: CurrentTheme(context).isDarkMode ? Colors.grey.shade300 : Colors.grey[200],
        inactiveThumbColor: CurrentTheme(context).isDarkMode ? Colors.grey : Colors.grey[300],
      ),
    );
  }
}

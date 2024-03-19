import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_page.dart';

class MainPageParent extends StatefulWidget {
  const MainPageParent({required String tab,Key? key}) : super(key: key);

  @override
  State<MainPageParent> createState() => _MainPageParentState();
}

class _MainPageParentState extends State<MainPageParent> {
  @override
  Widget build(BuildContext context) {
    // var user = Provider.of<AuthFlowData>(context).firebaseUser;
    return const BetterFeedback(child: MainPage(tab: 'feed',));
  }
}

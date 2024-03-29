import 'dart:async';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/email_link_handler.dart';

/// Listens to [errorStream] and shows an alert dialog each time an error is received.
/// This widget should live for the entire lifecycle of the app, so that all errors are reported.
class EmailLinkErrorPresenter extends StatefulWidget {
  const EmailLinkErrorPresenter({Key? key, required this.child, required this.errorStream})
      : super(key: key);
  final Widget child;
  final Stream<EmailLinkError> errorStream;

  static Widget create(BuildContext context, {Widget? child}) {
    final FirebaseEmailLinkHandler linkHandler =
    Provider.of<FirebaseEmailLinkHandler>(context, listen: false);
    return EmailLinkErrorPresenter(
      child: child!,
      errorStream: linkHandler.errorStream,
    );
  }

  @override
  _EmailLinkErrorPresenterState createState() =>
      _EmailLinkErrorPresenterState();
}

class _EmailLinkErrorPresenterState extends State<EmailLinkErrorPresenter> {
  late StreamSubscription<EmailLinkError> _onEmailLinkErrorSubscription;

  @override
  void initState() {
    super.initState();
    _onEmailLinkErrorSubscription = widget.errorStream.listen((error) {
      // PlatformAlertDialog(
      //   title: Strings.activationLinkError,
      //   content: error.message,
      //   defaultActionText: Strings.ok,
      // ).show(context);
    });
  }

  @override
  void dispose() {
    _onEmailLinkErrorSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
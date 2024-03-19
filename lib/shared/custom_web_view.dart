import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skibble/utils/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'custom_app_bar.dart';


class CustomWebView extends StatefulWidget {
  final String webUrl;
  final String title;
  final VoidCallback? customWillPop;
  final WebViewController? controller;

  CustomWebView({required this.webUrl, required this.title, this.customWillPop, this.controller});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {

  late final WebViewController controller;


  bool isLoading=true;
  final _key = UniqueKey();
  double opacity = 0;
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    controller = widget.controller != null ? widget.controller! : WebViewController()
      ..loadRequest(
        Uri.parse(widget.webUrl),
      );
  }


  Future<bool> _willPopCallback() async {
    WebViewController webViewController = controller;
    bool canNavigate = await webViewController.canGoBack();
    if (canNavigate) {
      webViewController.goBack();
      return false;
    }
    else {
      if(widget.customWillPop != null) {

        widget.customWillPop!();

      }

      Navigator.pop(context);
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onBackPressed: _willPopCallback,
        title: widget.title,
        actions: const [
          // NavigationControls(controller: controller),
        ],
      ),

      body: WebViewStack(controller: controller,),
    );
  }
}


class WebViewStack extends StatefulWidget {

  final WebViewController controller;

  WebViewStack({required this.controller});

  @override
  _WebViewStackState createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {

  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller..setNavigationDelegate(NavigationDelegate(
      onPageStarted: (url) {
        setState(() {
          loadingPercentage = 0;
        });
      },
      onProgress: (progress) {
        setState(() {
          loadingPercentage = progress;
        });
      },
      onPageFinished: (url) {
        setState(() {
          loadingPercentage = 100;
        });
      },
    ))..setJavaScriptMode(JavaScriptMode.unrestricted);

  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: widget.controller,                     // MODIFY
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}


class NavigationControls extends StatelessWidget {
  const NavigationControls({required this.controller, super.key});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kDarkSecondaryColor,),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await controller.canGoBack()) {
              await controller.goBack();
            } else {
              messenger.showSnackBar(
                const SnackBar(content: Text('No back history item')),
              );
              return;
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, color: kDarkSecondaryColor,),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await controller.canGoForward()) {
              await controller.goForward();
            } else {
              messenger.showSnackBar(
                const SnackBar(content: Text('No forward history item')),
              );
              return;
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay, color: kDarkSecondaryColor,),
          onPressed: () {
            controller.reload();
          },
        ),
      ],
    );
  }
}


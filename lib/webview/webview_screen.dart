// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewScreen extends StatefulWidget {
  final url;

  WebViewScreen(this.url);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  final _webViewPlugin = FlutterWebviewPlugin();
  
  @override
  void initState() {
    super.initState();
    _webViewPlugin.onDestroy.listen((_) {
      if (Navigator.canPop(context)) {
        // exiting the screen
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.url);
    return WillPopScope(
        child: WebviewScaffold(
          hidden: true,
          url: '${widget.url}',
          withZoom: false,
          withLocalStorage: true,
          withJavascript: true,
          appCacheEnabled: true,
          appBar: AppBar(
            title: Text("Zoom"),
          ),
        ),
        onWillPop: () {
          return _webViewPlugin.close();
        }
    );
  }
}

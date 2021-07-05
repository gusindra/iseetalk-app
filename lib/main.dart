import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(
  title: 'iSeeTalk',
  theme: ThemeData(
    primarySwatch: Colors.deepOrange,
  ),
  home: MyHomePage(),
));

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

WebViewController controllerGlobal;

Future<bool> _exitApp(BuildContext context) async {
  if (await controllerGlobal.canGoBack()) {
    print("onwill goback");
    controllerGlobal.goBack();
  } else {
    Scaffold.of(context).showSnackBar(
      const SnackBar(content: Text("No back history item")),
    );
    return Future.value(false);
  }
}

class _MyHomePageState extends State<MyHomePage> {

  WebViewController _webViewController;
  TextEditingController _teController = new TextEditingController();
  bool showLoading = false;

  void updateLoading(bool ls) {
    this.setState((){
      showLoading = ls;
    });
  }

  Future<bool> _handleBack(context) async {
    if (await _webViewController.canGoBack()) {
      print('can go back');
      _webViewController.goBack();
      return Future.value(false);
    } else {
      return (await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to exit iSeeTalk App'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: new Text('Yes'),
            ),
          ],
        ),
      )) ?? Future.value(true);
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _handleBack(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  flex: 10,
                  child: Stack(
                    children: <Widget>[
                      WebView(
                        initialUrl: 'https://iseetalk.com',
                        onPageFinished: (data){
                          updateLoading(false);
                        },
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (webViewController){
                          _webViewController = webViewController;
                        },
                      ),
                      (showLoading)?Center(child: CircularProgressIndicator(),):Center()
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


import 'dart:io';

import '../imports.dart';
import 'dart:async';

class OpenLink extends StatefulWidget {
  @override
  _OpenLinkState createState() => _OpenLinkState();
}

class _OpenLinkState extends State<OpenLink> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<ConnectionType>(context);
    WebParam param = ModalRoute.of(context).settings.arguments;

    var link = param.url;
    bool isOrderLink = param.type == LinkType.ORDER;
    link = helper.checkStartwithHttps(param.url);

    JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
      return JavascriptChannel(
          name: 'Toaster',
          onMessageReceived: (JavascriptMessage message) {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          });
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: isOrderLink
            ? null
            : FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                backgroundColor: param.color,
                child: Text(
                  t_go_back,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
        body: network == ConnectionType.offline
            ? ShowOffline()
            : Container(
                child: Column(
                  children: <Widget>[
                    (progress != 1.0)
                        ? LinearProgressIndicator(value: progress)
                        : null,
                    Expanded(
                      child: Container(
                        child: WebView(
                          initialUrl: link,
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated:
                              (WebViewController webViewController) {
                            _controller.complete(webViewController);
                          },
                          javascriptChannels: <JavascriptChannel>[
                            _toasterJavascriptChannel(context),
                          ].toSet(),
                          navigationDelegate: (NavigationRequest request) {
                            return NavigationDecision.navigate;
                          },
                          onPageStarted: (String url) {},
                          onPageFinished: (String url) {
                            setState(() => progress = 1);
                          },
                          gestureNavigationEnabled: true,
                        ),
                      ),
                    ),
                  ].where((Object o) => o != null).toList(),
                ),
              ),
      ),
    );
  }
}

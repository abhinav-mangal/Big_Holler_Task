import 'dart:ui';
import '../imports.dart';

class LocTitle extends StatelessWidget {
  final String title;
  final Color appColor;
  final bool multiLocs;
  LocTitle(this.title, this.appColor, {this.multiLocs = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.location_on, color: appColor),
                    SizedBox(width: 10),
                    Container(
                      child: MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaleFactor: 1,
                        ),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    multiLocs ? SizedBox(width: 10) : SizedBox(),
                    multiLocs
                        ? Icon(Icons.more_vert, color: Colors.white)
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

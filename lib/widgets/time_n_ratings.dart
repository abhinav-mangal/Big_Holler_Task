import '../imports.dart';

class TimeNRatings extends StatelessWidget {
  final Location location;
  final int lines;
  final double spacing;
  final MainAxisAlignment ratingAlignment;
  final Color appColor;
  final bool clickable;
  final bool showRatings;
  TimeNRatings({
    this.location,
    this.lines = 1,
    this.spacing = 0,
    this.ratingAlignment = MainAxisAlignment.start,
    this.appColor = PrimaryColor,
    this.clickable = true,
    this.showRatings = true,
  });

  @override
  Widget build(BuildContext context) {
    String _timingsFull = "", _timingsOneLine = "";
    bool reviewLink = false;
    Image reviewProvider;
    var closeInfo = location.locationCloseTime != null &&
            location.locationCloseTime.isNotEmpty
        ? " " + location.locationCloseTime
        : "";
    //Text for working hours
    _timingsOneLine = location.locationOpen
        ? msg_currentlyOpen + closeInfo
        : msg_currentlyClosed + "";
    _timingsFull = (location.locationOpen
            ? msg_currentlyOpen + closeInfo + "\n\n"
            : msg_currentlyClosed + "\n\n") +
        location.hoursOfOperation.list.map((h) => h.description).join("\n");

    //Visibility of rating and the provider
    reviewLink =
        location.reviewsLink != null && location.reviewsLink.isNotEmpty;
    if (reviewLink) {
      var img = "";
      if (location.reviewsLink.contains('yelp'))
        img = img_yelp;
      else if (location.reviewsLink.contains('google'))
        img = img_google;
      else
        reviewLink = false;

      reviewProvider = Image.asset(
        img,
        height: 18,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        showRatings && location.isRatingAvailable
            ? reviewLink
                ? InkWell(
                    onTap: clickable
                        ? () => Navigator.pushNamed(
                              context,
                              P_OpenLink,
                              arguments: WebParam(
                                location.reviewsLink,
                                appColor,
                                LinkType.INAPP,
                              ),
                            )
                        : null,
                    child: Row(
                      mainAxisAlignment: ratingAlignment,
                      children: <Widget>[
                        reviewProvider,
                        const SizedBox(width: 5),
                        RatingBarIndicator(
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: reviewLink ? appColor : Colors.amber,
                          ),
                          itemSize: 18,
                          rating: location.avgRating,
                        ),
                        AppText(' ${location.avgRating}', bold: true),
                        clickable
                            ? Icon(Icons.more_vert, color: appColor)
                            : const SizedBox()
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: ratingAlignment,
                    children: <Widget>[
                      RatingBarIndicator(
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemSize: 18,
                        rating: location.avgRating,
                      ),
                      AppText(' ${location.avgRating}', bold: true),
                    ],
                  )
            : const SizedBox(),
        if (spacing > 0) SizedBox(height: spacing),
        InkWell(
          onTap: clickable
              ? () => alertDialog(
                    context,
                    appColor,
                    _timingsFull,
                  )
              : null,
          child: Row(
            mainAxisAlignment: ratingAlignment,
            children: <Widget>[
              Icon(Icons.access_time, color: appColor, size: 16),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  _timingsOneLine,
                  overflow: TextOverflow.ellipsis,
                  maxLines: lines,
                ),
              ),
              clickable
                  ? Icon(Icons.more_vert, color: appColor)
                  : const SizedBox()
            ],
          ),
        ),
      ],
    );
  }
}

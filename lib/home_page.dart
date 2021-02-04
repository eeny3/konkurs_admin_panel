import 'package:flutter/material.dart';
import 'package:konkurs_admin/upload_post.dart';
import 'package:line_icons/line_icons.dart';
import 'package:vertical_tabs/vertical_tabs.dart';
import 'posts.dart';
import 'closed_posts.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {

  int _pageIndex = 0;

  final List<String> titles = [
    'Конкурсы',
    'Завершенные конкурсы',
    'Создать конкурс',
  ];

  final List icons = [
    LineIcons.rocket,
    Icons.location_disabled,
    LineIcons.arrow_circle_up,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                child: VerticalTabs(
                  tabBackgroundColor: Colors.white,
                  backgroundColor: Colors.grey[200],
                  tabsElevation: 10,
                  tabsShadowColor: Colors.grey[500],
                  tabsWidth: 200,
                  indicatorColor: Colors.deepPurpleAccent,
                  selectedTabBackgroundColor: Colors.deepPurpleAccent.withOpacity(0.1),
                  indicatorWidth: 5,
                  disabledChangePageFromContentView: true,
                  initialIndex: _pageIndex,
                  onSelect: (index){
                    _pageIndex = index;
                  },
                  tabs: <Tab>[
                    tab(titles[0], icons[0]),
                    tab(titles[1], icons[1]),
                    tab(titles[2], icons[2]),
                  ],
                  contents: <Widget>[
                    CoverWidget(widget: Posts()),
                    CoverWidget(widget: ClosedPosts()),
                    CoverWidget(widget: UploadPost()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _appBar (){
  return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: Container(
        height: 60,
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 10,
                  offset: Offset(0, 5)
              )
            ]
        ),
        child: Row(
          children: <Widget>[
            RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.deepPurpleAccent),
                    text: 'Konkurs app: ',
                    children: <TextSpan>[
                      TextSpan(
                          text: ' - Admin Panel',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800])
                      )
                    ])),
            Spacer(),
          ],
        ),
      )

  );
}

Widget tab(title, icon) {
  return Tab(
      child: Container(
        padding: EdgeInsets.only(left: 10,),
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              icon, size: 20, color: Colors.grey[800],
            ),
            SizedBox(
              width: 5,
            ),
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[900], fontWeight: FontWeight.w600),)
          ],
        ),
      ));
}

class CoverWidget extends StatelessWidget {
  final widget;
  const CoverWidget({Key key, @required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
        padding: EdgeInsets.only(
          left: w * 0.05,
          right: w * 0.20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey[300], blurRadius: 10, offset: Offset(3, 3))
          ],
        ),
        child: widget

    );
  }
}
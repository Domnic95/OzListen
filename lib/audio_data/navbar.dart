import 'package:flutter/material.dart';
import 'package:com.ozlisten.ozlistenapp/tabcontroller/tabs.dart';
import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.bottomCenter,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width/10,
              minWidth: MediaQuery.of(context).size.width/10,
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)
                => TabContainerBottom(selectedIndex: MAIN_FREE,)));
              },
            ),
          ),

          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width/1.5,
              minWidth: MediaQuery.of(context).size.width/1.7,
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
            child: Text('Playing Now',textAlign: TextAlign.start,style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w500),),
          ),
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  void onTabTapped(int index) {
    if(index == 0){
     // Navigator.push(BuildContext, MaterialPageRoute(builder: (_) => Load_audio()));
    }

  }
  const NavBarItem({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      child: Icon(
        icon,
        color: primaryColor,
      ),
    );
  }

}

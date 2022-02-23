import 'package:flutter/material.dart';

class HtmlAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onPressed;
  final List<Widget> actions;
  final AppBar _appBar = AppBar();

  HtmlAppBar({
    Key key,
    this.title,
    this.onPressed,
    this.actions = null,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
        ),
        onPressed: onPressed ?? () => Navigator.of(context).pop(),
      ),
      title: Text(
        title ?? 'HTML page',
        style: TextStyle(fontSize: 16),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_appBar.preferredSize.height);
}

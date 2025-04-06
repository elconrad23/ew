import 'package:flutter/material.dart';

class AppBarBase extends StatelessWidget implements PreferredSizeWidget{
  const AppBarBase({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: Colors.black,)),
       backgroundColor: Theme.of(context).colorScheme.secondary,
      elevation: 0.0,
     );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.maxFinite, 50);
}

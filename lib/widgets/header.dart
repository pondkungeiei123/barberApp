import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_manager/data_manager.dart';
import '../theme/text_styles.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "สวัสดี,",
          style: TextStyles.title,
        ),
        Text(
            Provider.of<DataManagerProvider>(context)
                .currentUser
                .customerFirstName,
            style: TextStyles.h1Style),
      ],
    ).p16;
  }
}

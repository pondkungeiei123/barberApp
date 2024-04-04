import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';

import '../theme/text_styles.dart';

class WorkingsHeader extends StatelessWidget {
  const WorkingsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 40.0,
        ),
        Text(
          "รูปภาพผลงาน",
          style: TextStyles.titleM,
        ),
      ],
    ).p16;
  }
}

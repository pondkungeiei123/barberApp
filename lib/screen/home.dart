import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_manager/data_manager.dart';
import '../php_data/firebase_data.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../widgets/dashboard/barber_list_widget.dart';
import '../widgets/header.dart';
import '../widgets/searching_screen.dart';

class UserHome extends StatefulWidget {
  UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  bool searchingStart = false;

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      if (textController.text.isNotEmpty) {
        Provider.of<DataManagerProvider>(context, listen: false)
            .searchList
            .clear();
        Provider.of<DataManagerProvider>(context, listen: false)
            .setIsSearching(true);
        Provider.of<DataManagerProvider>(context, listen: false)
            .getSearch(textController.text);
      } else {
        Provider.of<DataManagerProvider>(context, listen: false)
            .setIsSearching(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getAllBarbers(context);
    return Scaffold(
      body: Consumer<DataManagerProvider>(
        builder: (context, providerData, child) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const Header(),
                    Container(
                      height: 55,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(13)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: LightColor.grey.withOpacity(.8),
                            blurRadius: 15,
                            offset: Offset(5, 5),
                          )
                        ],
                      ),
                      child: TextField(
                        controller: textController,
                        onChanged: (value) {
                          print(value);
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          border: InputBorder.none,
                          hintText: "Search...",
                          hintStyle: TextStyles.body.subTitleColor,
                          suffixIcon: SizedBox(
                            width: 50,
                            child: Icon(Icons.search, color: LightColor.purple)
                                .alignCenter
                                .ripple(
                                  () {},
                                  borderRadius: BorderRadius.circular(13),
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Provider.of<DataManagerProvider>(context).searchingStart
                  ? const SearchingScreen()
                  : barbersList(providerData.getAllBarbers, context),
            ],
          );
        },
      ),
    );
  }
}

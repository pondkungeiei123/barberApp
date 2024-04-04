// ignore_for_file: library_private_types_in_public_api

import 'package:finalprojectbarber/php_data/php_data.dart';

import 'package:finalprojectbarber/screen/workings_add_details_screen.dart';
import 'package:finalprojectbarber/widgets/workings_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_manager/data_manager.dart';
import '../widgets/dashboard/workings_list_widget.dart';

class WorkingsPage extends StatefulWidget {
  const WorkingsPage({
    Key? key,
  }) : super(key: key);

  @override
  _WorkingsPageState createState() => _WorkingsPageState();
}

class _WorkingsPageState extends State<WorkingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getAllWorkings(context);
    return Scaffold(
      body: Consumer<DataManagerProvider>(
        builder: (context, providerData, child) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const WorkingsHeader(),
                  ],
                ),
              ),
              WorkingsList(providerData.getAllWorkings, context),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => WorkingsAddDetailScreen(
                    id: Provider.of<DataManagerProvider>(context, listen: false)
                        .barberProfile
                        .barberId)),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

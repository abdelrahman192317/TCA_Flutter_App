import 'package:flutter/material.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'package:provider/provider.dart';
import 'package:app2m/provider/my_provider.dart';

import 'dates_list_screen.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MyPro>(context, listen: false).getData();
      Provider.of<MyPro>(context, listen: false).getUser();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<MyPro>(
      builder: (ctx, val, _) {
        if(val.newMessage != ''){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            val.myShowDialog(context);
          });
        }
        return Scaffold(
          body: val.index == 2
              ? const Profile()
              : const DatesListScreen(),
          bottomNavigationBar: BottomNavyBar(
            containerHeight: size.height * 0.08,
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .background,
            selectedIndex: val.index,
            onItemSelected: (index) => val.moveIndex(index),
            items: [
              BottomNavyBarItem(
                  activeColor: Theme
                      .of(context)
                      .primaryColor,
                  icon: const Icon(Icons.home),
                  title: const Text('Home')),
              BottomNavyBarItem(
                  activeColor: Theme
                      .of(context)
                      .primaryColor,
                  icon: const Icon(Icons.archive_outlined),
                  title: const Text('Archive')),
              BottomNavyBarItem(
                  activeColor: Theme
                      .of(context)
                      .primaryColor,
                  icon: const Icon(Icons.person_outline),
                  title: const Text('Profile')),
            ],
          ),
        );
      }
    );
  }
}

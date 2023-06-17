import 'package:app2m/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../../provider/my_provider.dart';

import '../../widgets/doctor_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro>(
      builder: (ctx, val, _) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(size.height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.03),

                IconButton(
                  onPressed: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const HomeScreen())
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),

                SizedBox(height: size.height * 0.02),
                Text('Notifications', style: Theme.of(context).textTheme.headlineSmall),

                SizedBox(height: size.height * 0.02),
                const Text('These Notifications are when your Elderly is in danger', style: TextStyle(fontSize: 15, color: Colors.grey),),

                SizedBox(height: size.height * 0.01),

                Expanded(
                  child: ListView.separated(
                    itemBuilder: (ctx, index) => Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        padding: const EdgeInsets.all(15),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red,
                        ),
                        child: const Icon(Icons.delete),
                      ),
                      secondaryBackground: Container(
                        padding: const EdgeInsets.all(15),
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red,
                        ),
                        child: const Icon(Icons.delete),
                      ),
                      onDismissed: (_) => val.deleteNotification(index),
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: Container(
                          height: size.height * 0.14,
                          padding: EdgeInsets.all(size.width * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.height * 0.08,
                                height: size.height * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  color: Theme.of(context).focusColor,
                                ),
                                child: const Icon(Icons.notifications, color: Colors.red,),
                              ),
                              SizedBox(width: size.width * 0.05),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(val.notificationCardList[index].title, style: Theme.of(context).textTheme.titleLarge,),
                                  SizedBox(
                                    width: size.width * 0.6,
                                      child: Text(
                                        val.notificationCardList[index].body,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        overflow: TextOverflow.fade, softWrap: false)
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time_filled, color: Theme.of(context).primaryColor,),
                                      SizedBox(width: size.width * 0.01,),
                                      Text(DateFormat('HH:mm a,  dd/MM').format(val.notificationCardList[index].dateTime!)),
                                    ],
                                  ),
                                ],
                              ),
                            ],

                          ),
                        ),
                      ),
                    ),
                    itemCount: val.notificationCardList.length,
                    separatorBuilder: (ctx, index) => SizedBox(height: size.height * 0.02,),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

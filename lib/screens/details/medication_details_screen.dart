import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '../../provider/my_provider.dart';

import 'package:app2m/models/medication_models.dart';

import '../home/home_screen.dart';

class OrderDetailsScreen extends StatelessWidget {
  final MedicationDates medication;

  const OrderDetailsScreen({Key? key, required this.medication}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro>(
        builder: (ctx, val, _) => Scaffold(
          body: Padding(
            padding: EdgeInsets.all(size.height * 0.01),
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

                Card(
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.01),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                height: size.height * 0.14,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15)
                                  ),
                                  child: Hero(
                                      tag: medication.medicineId,
                                      child: Image.file(File(medication.imageUrl),fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: ListTile(
                                title: Text(medication.medicineName),
                                subtitle: Text(medication.desc),
                              ),
                            ),
                          ],
                        ),
                        const Divider(thickness: 2,),
                        Padding(
                          padding: EdgeInsets.all(size.width * 0.03),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, color: Theme.of(context).primaryColor,),
                                  SizedBox(width: size.width * 0.01,),
                                  Text(medication.doctorName),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.access_time_filled_rounded, color: Theme.of(context).primaryColor,),
                                          SizedBox(width: size.width * 0.01,),
                                          Text('Start Time: ${DateFormat('MM/dd').format(medication.startDateTime)}'),
                                        ],
                                      ),

                                      Text('Done: ${medication.done} / ${medication.repeatInDay * medication.daysNum}'),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.access_time_filled_rounded, color: Theme.of(context).primaryColor,),
                                          SizedBox(width: size.width * 0.01,),
                                          Text('End Time: ${DateFormat('MM/dd').format(medication.endDateTime!)}'),
                                        ],
                                      ),

                                      Text('Medication Type: ${medication.type}'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.separated(
                    itemBuilder: (ctx, index) => Card(
                      color: medication.datesList![index].done? Colors.green[200] : Theme.of(context).cardTheme.color,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          child: Icon(Icons.access_time_filled_rounded, color: Theme.of(context).primaryColor,),
                        ),
                        title: Text(DateFormat('MM/dd,  HH:mm a').format(medication.datesList![index].dateTime)),
                        trailing: Icon(
                          medication.datesList![index].archived? Icons.archive : Icons.access_time_filled,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    itemCount: medication.datesList!.length,
                    separatorBuilder: (ctx, index) => SizedBox(height: size.height * 0.02),
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }
}
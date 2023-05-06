import 'dart:io';
import 'package:app2m/provider/my_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/details/order_details_screen.dart';
import '../models/medication_models.dart';

class MedicationCard extends StatelessWidget {
  final MDateCard mdc;

  const MedicationCard({
    Key? key,
    required this.mdc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<MyPro>(
      builder: (ctx, val, _) {
        return Dismissible(
          key: UniqueKey(),
          background: background(false),
          secondaryBackground: background(true),
          onDismissed: (DismissDirection dir) {
            dir == DismissDirection.startToEnd ?
            val.archiveMDate(mdc.medicineId, mdc.dateTime!) : val.deleteFromMDsList(mdc.medicineId, mdc.dateTime!);
          },
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrderDetailsScreen(order: val.getMDate(mdc.medicineId)))
              );
            },
            child: Row(
              children: [
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: size.height * 0.14,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Hero(
                            tag: mdc.medicineId,
                            child: Image.file(File(mdc.imageUrl),fit: BoxFit.cover)),
                      ),
                    )
                ),
                Expanded(
                    flex: 8,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15)
                      ),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: size.height * 0.12,
                            child: Row(
                              children: [
                                Expanded(flex:  mdc.done,
                                    child: Container(decoration: BoxDecoration(color: Colors.green.withOpacity(0.5)),)
                                ),
                                Expanded(flex:  mdc.notDone,
                                    child: Container()
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(size.width * 0.01),
                            child: ListTile(
                              title: Text(mdc.medicineName, overflow: TextOverflow.ellipsis, softWrap: true, maxLines: 1,),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(mdc.desc, overflow: TextOverflow.ellipsis, softWrap: true, maxLines: 1,),
                                  SizedBox(height: size.height * 0.01,),
                                  Text(DateFormat('MM/dd, hh:mm a').format(mdc.dateTime!)),
                                ],
                              ),
                              trailing: SizedBox(
                                width: size.width * 0.17,
                                  child: Text(mdc.type, overflow: TextOverflow.ellipsis, softWrap: true, maxLines: 1,)),
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
        );
      }
    );
  }
  Widget background(bool dir){
    return Container(
      padding: const EdgeInsets.all(15),
      alignment: dir? Alignment.centerRight : Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: dir? Colors.red : Colors.green,
      ),
      child: Icon(dir? Icons.delete : Icons.archive),
    );
  }
}

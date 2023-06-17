import 'dart:io';
import 'package:app2m/provider/my_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/details/medication_details_screen.dart';
import '../models/medication_models.dart';
import 'alert_confirm.dart';

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
          background: val.index == 1 ? background(true, true) : background(true, false),
          secondaryBackground: val.index == 1 ? background(false, true) : background(false, false),
          onDismissed: (DismissDirection dir) {
            val.index == 1 ? showDialog(context: context, builder: (_) => AlertConfirmWidget(
                title: 'Delete Date', onPress: (){
              val.deleteFromMDsList(mdc.medicineId, mdc.dateTime!);
              Navigator.pop(context);
              val.toast(context, "This Date Is Removed", isRed: true);
            })) :
            dir == DismissDirection.startToEnd ?
            showDialog(context: context, builder: (_) => AlertConfirmWidget(
                title: 'Archive Date', onPress: (){
              val.archiveMDate(mdc.medicineId, mdc.dateTime!);
              Navigator.pop(context);
              val.toast(context, "This Date Is Archived");
            })) :
            showDialog(context: context, builder: (_) => AlertConfirmWidget(
                title: 'Delete Date', onPress: (){
              val.deleteFromMDsList(mdc.medicineId, mdc.dateTime!);
              Navigator.pop(context);
              val.toast(context, "This Date Is Removed", isRed: true);
            }));
          },
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrderDetailsScreen(medication: val.getMDate(mdc.medicineId)))
              );
            },
            child: Card(
              child: Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: size.height * 0.14,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              topLeft: Radius.circular(15)
                          ),
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
                              height: size.height * 0.14,
                              child: Row(
                                children: [
                                  Expanded(flex:  mdc.done,
                                      child: Container(decoration: BoxDecoration(color: Colors.green[200]),)
                                  ),
                                  Expanded(flex:  mdc.notDone,
                                      child: Container()
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.all(size.width * 0.02),
                              title: Text(mdc.medicineName, overflow: TextOverflow.ellipsis, softWrap: false, maxLines: 1,),
                              subtitle: Row(
                                children: [
                                  Icon(Icons.access_time_filled_outlined, color: Theme.of(context).primaryColor,),
                                  SizedBox(width: size.width * 0.01,),
                                  Text(DateFormat('dd/MM, hh:mm a').format(mdc.dateTime!)),
                                ],
                              ),
                              trailing: Container(
                                alignment: Alignment.center,
                                width: size.width * 0.1,
                                child: Text(mdc.type, overflow: TextOverflow.ellipsis, softWrap: false, maxLines: 1,),
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
  Widget background(bool dir, bool arc){
    return Container(
      padding: const EdgeInsets.all(15),
      alignment: dir? Alignment.centerLeft : Alignment.centerRight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: !arc && dir? Colors.green : Colors.red,
      ),
      child: Icon(!arc && dir? Icons.archive : Icons.delete),
    );
  }
}

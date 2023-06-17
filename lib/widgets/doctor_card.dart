import 'package:app2m/provider/my_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/details/doctor_details_screen.dart';
import '../models/doctor_models.dart';
import 'alert_confirm.dart';

class DoctorCard extends StatelessWidget {
  final DDateCard ddc;

  const DoctorCard({Key? key, required this.ddc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<MyPro>(
      builder: (ctx, val, _) {
        return GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => DoctorDsDetails(doctor: val.getDDate(ddc.doctorId)))
          ),
          child: Dismissible(
            key: UniqueKey(),
            background: val.index == 1 ? background(true, true) : background(true, false),
            secondaryBackground: val.index == 1 ? background(false, true) : background(false, false),
            onDismissed: (DismissDirection dir) {
              val.index == 1 ? showDialog(context: context, builder: (_) => AlertConfirmWidget(
                  title: 'Delete Date', onPress: (){
                val.deleteFromDDsList(ddc.doctorId, ddc.dateTime!);
                Navigator.pop(context);
                val.toast(context, "Doctor ${ddc.doctorName} Date Removed", isRed: true);
              })) :
              dir == DismissDirection.startToEnd ?
              showDialog(context: context, builder: (_) => AlertConfirmWidget(
                  title: 'Archive Date', onPress: (){
                val.archiveDDate(ddc.doctorId, ddc.dateTime!);
                Navigator.pop(context);
                val.toast(context, "Doctor ${ddc.doctorName} Date Archived");
              })) :
              showDialog(context: context, builder: (_) => AlertConfirmWidget(
                  title: 'Delete Date', onPress: (){
                val.deleteFromDDsList(ddc.doctorId, ddc.dateTime!);
                Navigator.pop(context);
                val.toast(context, "Doctor ${ddc.doctorName} Date Removed", isRed: true);
              }));
            },
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

                      child: Icon(Icons.person, color: Theme.of(context).primaryColor,),
                    ),
                    SizedBox(width: size.width * 0.05),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(ddc.doctorName, style: Theme.of(context).textTheme.titleMedium,),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time_filled, color: Theme.of(context).primaryColor,),
                            SizedBox(width: size.width * 0.01,),
                            Text(DateFormat('dd/MM,  HH:mm a').format(ddc.dateTime!)),
                          ],
                        ),
                      ],
                    ),
                  ],

                ),
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

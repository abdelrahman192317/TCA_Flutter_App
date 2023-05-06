import 'package:app2m/provider/my_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/details/doctor_details_screen.dart';
import '../models/doctor_models.dart';

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
            background: background(false),
            secondaryBackground: background(true),
            onDismissed: (DismissDirection dir) {
              dir == DismissDirection.startToEnd ?
              val.archiveDDate(ddc.doctorId, ddc.dateTime!) : val.deleteFromDDsList(ddc.doctorId, ddc.dateTime!);
            },
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.01),
                child: ListTile(
                  title: Text(ddc.doctorName),
                  subtitle: Text(DateFormat('MM/dd,  HH:mm a').format(ddc.dateTime!)),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(ddc.type),
                      Text(ddc.location),
                    ],
                  ),
                ),
              ),
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

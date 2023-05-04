import 'package:flutter/material.dart';

import '../screens/details/doctor_details_screen.dart';
import '../models/doctor_models.dart';

class DoctorCard extends StatelessWidget {
  final DoctorDates dds;

  const DoctorCard({Key? key, required this.dds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => Navigator.push(
        context, MaterialPageRoute(
          builder: (context) => DoctorDsDetails(doctor: dds))
      ),
      child: Card(
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.01),
          child: ListTile(
            title: Text(dds.doctorName),
            subtitle: dds.datesList == null? null: Text('Date: ${dds.datesList![0].dateTime}'),
            trailing: Text(dds.type),
          ),
        ),
      )
    );
  }
}

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../provider/my_provider.dart';

import 'package:app2m/models/doctor_models.dart';

class DoctorDsDetails extends StatelessWidget {
  final DoctorDates doctor;

  const DoctorDsDetails({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro>(
        builder: (ctx, val, _) => Scaffold(
          appBar: AppBar(title: Text(doctor.doctorName)),
          extendBodyBehindAppBar: true,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: size.height * 0.04),

              SizedBox(
                width: size.width,
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Description'),
                        Text(doctor.type,maxLines: 4,),
                        TextButton(onPressed: (){}, child: Text(doctor.phoneNumber)),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                width: size.width,
                height: size.height * 0.08,
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        )
    );
  }
}
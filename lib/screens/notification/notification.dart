import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:provider/provider.dart';

import '../../provider/my_provider.dart';

import '../add/add_doctor_date.dart';
import '../add/add_medication_date.dart';

import '../../models/medication_models.dart';
import '../../widgets/medication_card.dart';

import '../../widgets/doctor_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro>(
      builder: (ctx, val, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('NotificationScreen'),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
                val.nullErrorMessage();
                val.falsePickers();
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (ctx, index) => (val.getDs(index) is MDateCard)?
                    MedicationCard(mdc: val.dsList[index]) :
                    DoctorCard(ddc: val.dsList[index]),
                  itemCount: val.count,
                  separatorBuilder: (ctx, index) => SizedBox(height: size.height * 0.02,),
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.02)
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

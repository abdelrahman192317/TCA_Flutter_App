import 'package:app2m/screens/notification/notification.dart';
import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:provider/provider.dart';

import '../../provider/my_provider.dart';

import '../add/add_doctor_date.dart';
import '../add/add_medication_date.dart';

import '../../models/medication_models.dart';
import '../../widgets/medication_card.dart';

import '../../widgets/doctor_card.dart';

class DatesListScreen extends StatelessWidget {
  const DatesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro>(
      builder: (ctx, val, _) {
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.06),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Hero(
                      tag: val.user.userName,
                      child: Image.asset('assets/images/old_avatar.jpg',
                        width: size.width * 0.14,
                        height: size.height * 0.18,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text('Hi , ${val.user.userName}'),
                  subtitle: const Text('Welcome'),
                  trailing: IconButton(
                    onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const NotificationScreen()));
                      //val.setAlarm();
                      //val.scheduleNotification(DateTime.now().add(const Duration(seconds: 1)), 'First one', 'no thing to write');
                    },
                    icon: const Icon(Icons.notifications_active),
                  ),
                ),
              ),
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
          floatingActionButton: val.index != 0? null : SpeedDial(
              icon: Icons.add,
              activeIcon: Icons.close,
              elevation: 6,
              spaceBetweenChildren: 15,
              childrenButtonSize: const Size(60,60),
              overlayColor: Colors.transparent,
              children: [
                SpeedDialChild(
                    label: 'Medication Date',
                    labelStyle: const TextStyle(fontSize: 20),
                    child: const Icon(Icons.medical_services_outlined),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const AddMedication()));
                    }
                ),
                SpeedDialChild(
                    label: 'Doctor Date',
                    labelStyle: const TextStyle(fontSize: 20),
                    child: const Icon(Icons.more_time_outlined),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const AddDoctor()));
                    }
                ),
              ]
          ),
        );
      }
    );
  }
}

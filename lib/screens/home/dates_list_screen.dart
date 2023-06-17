
import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:provider/provider.dart';

import '../../provider/my_provider.dart';

import '../add/add_doctor_date.dart';
import '../add/add_medication_date.dart';

import '../../models/medication_models.dart';
import '../../widgets/medication_card.dart';

import '../../widgets/doctor_card.dart';
import '../notification/notification_screen.dart';

class DatesListScreen extends StatelessWidget {
  const DatesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro>(builder: (ctx, val, _) {
      return Scaffold(
        body: Column(
          children: [
            SizedBox(height: size.height * 0.06),
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Hero(
                  tag: val.user.userName,
                  child: Image.asset(
                    'assets/images/old_avatar.jpg',
                    width: size.width * 0.14,
                    height: size.height * 0.18,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text('Hi , ${val.user.userName}'),
              subtitle: const Text('Welcome'),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
                  val.resetIsRead();
                },
                icon: Stack(
                    children: [
                      Icon(
                        Icons.notifications_active,
                        color: Theme.of(context).primaryColor,
                      ),
                      if(!val.isRead) Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: size.width * 0.02,
                          height: size.width * 0.02,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),

            val.count == 0?
            Expanded(
              child:
              Center(
                child: Text(
                  'You Don\'t Have Any Dates, Try to Add Some',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                )
              ),
            )
                :
            Expanded(
              child: ListView.separated(
                  itemBuilder: (ctx, index) => (val.getDs(index) is MDateCard)
                      ? MedicationCard(mdc: val.getDsList(index))
                      : DoctorCard(ddc: val.getDsList(index)),
                  itemCount: val.count,
                  separatorBuilder: (ctx, index) => SizedBox(height: size.height * 0.01),
                  padding:
                      EdgeInsets.symmetric(horizontal: size.height * 0.01)),
            ),
          ],
        ),
        floatingActionButton: val.index != 0
            ? null
            : SpeedDial(
                icon: Icons.add,
                activeIcon: Icons.close,
                spaceBetweenChildren: 10,
                childrenButtonSize: const Size(55, 55),
                children: [
                    SpeedDialChild(
                        label: 'Medication',
                        labelBackgroundColor: Theme.of(context).hintColor,
                        labelStyle: TextStyle(color: Theme.of(context).primaryColor ,fontSize: 17),
                        backgroundColor: Theme.of(context).hintColor,
                        child: Icon(
                          Icons.medical_services_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddMedication()));
                        }),
                    SpeedDialChild(
                        label: 'Doctor',
                        labelBackgroundColor: Theme.of(context).hintColor,
                        labelStyle: TextStyle(color: Theme.of(context).primaryColor ,fontSize: 17),
                        backgroundColor: Theme.of(context).hintColor,
                        child: Icon(
                          Icons.more_time,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddDoctor()));
                        }),
                  ]),
      );
    });
  }
}

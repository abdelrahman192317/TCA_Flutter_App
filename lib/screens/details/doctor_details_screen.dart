import 'package:app2m/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';

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

                SizedBox(height: size.height * 0.02,),

                Card(
                  child:  Padding(
                    padding: EdgeInsets.all(size.width * 0.02),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              child: Icon(Icons.person, color: Theme.of(context).primaryColor,),
                            ),
                            SizedBox(width: size.width * 0.02,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.location_on_rounded, color: Theme.of(context).primaryColor,),
                              ],
                            ),
                            SizedBox(width: size.width * 0.02,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doctor.doctorName, style: Theme.of(context).textTheme.titleLarge,),
                                Text(doctor.location, style: Theme.of(context).textTheme.titleMedium,),
                                Text('specialty: ${doctor.type}', style: Theme.of(context).textTheme.titleMedium,),
                              ],
                            ),
                          ],
                        ),

                        const Divider(thickness: 1,),

                        InkWell(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.phone, color: Theme.of(context).primaryColor,),
                                SizedBox(width: size.width * 0.02,),
                                Text(doctor.phoneNumber, style: Theme.of(context).textTheme.bodyLarge,),
                              ],
                            ),
                          ),
                          onTap: () => launchUrl(Uri.parse('tel:+2${doctor.phoneNumber}')),
                        )
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.separated(
                      itemBuilder: (ctx, index) => Card(
                        color: doctor.datesList![index].done? Colors.green[200] : Theme.of(context).cardTheme.color,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            child: Icon(Icons.access_time_filled_rounded, color: Theme.of(context).primaryColor,),
                          ),
                          title: Text(DateFormat('MM/dd,  HH:mm a').format(doctor.datesList![index].dateTime)),
                          trailing: Icon(
                            doctor.datesList![index].archived? Icons.archive : Icons.access_time_filled,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      itemCount: doctor.datesList!.length,
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
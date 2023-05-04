import 'dart:io';
import 'package:flutter/material.dart';

import '../screens/details/order_details_screen.dart';
import '../models/medication_models.dart';

class MedicationCard extends StatelessWidget {
  final MedicationDates mds;

  const MedicationCard({
    Key? key,
    required this.mds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        //Provider.of<FavPro>(context, listen: false).updateId(movie.id);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OrderDetailsScreen(order: MedicationDates( startDateTime: DateTime.now())))
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
                      tag: mds.dateId,
                      child: Image.file(File(mds.imageUrl),fit: BoxFit.cover)),
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
                          Expanded(flex:  mds.done,
                              child: Container(decoration: const BoxDecoration(color: Colors.green),)
                          ),
                          Expanded(flex:  mds.datesList!.length - mds.done,
                              child: Container(decoration: const BoxDecoration(color: Colors.white),)
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.01),
                      child: ListTile(
                        title: Text(mds.medicineName),
                        subtitle: Text('${mds.datesList![0].dateTime.day}'),
                        trailing: Text(mds.type),
                      ),
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}

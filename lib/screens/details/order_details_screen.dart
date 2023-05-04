import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../provider/my_provider.dart';

import 'package:app2m/models/medication_models.dart';

class OrderDetailsScreen extends StatelessWidget {
  final MedicationDates order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro>(
        builder: (ctx, val, _) => Scaffold(
          appBar: AppBar(title: Text(order.medicineName)),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // order
                  SizedBox(height: size.height * 0.02),
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.2,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // title
                                Text(order.medicineName, overflow: TextOverflow.fade,),
                                // price + fees
                                const Text('${'order.price + order.fees'} point'),
                              ],
                            ),
                            Text('${order.done} at ${order.done}', overflow: TextOverflow.fade,),
                            const Text('${'order.distance'} km'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // user and receiver
                  SizedBox(height: size.height * 0.02),
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.25,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('User'),
                                const Text('order.userName'),
                                Row(
                                  children: const [
                                    Icon(Icons.location_on_sharp),
                                    Text('order.userLocation'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('order.userPN'),
                                    IconButton(onPressed: (){}, icon: const Icon(Icons.phone))
                                  ],
                                ),
                              ],
                            ),
                            Container(width: 1, height: size.height * 0.25,color: Colors.grey),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Receiver'),
                                const Text('order.receiverName'),
                                Row(
                                  children: const [
                                    Icon(Icons.location_on_sharp),
                                    Text('order.receiverLocation'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('order.receiverPN'),
                                    IconButton(onPressed: (){}, icon: const Icon(Icons.phone))
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app2m/provider/my_provider.dart';



class DoneConfirmWidget extends StatelessWidget {

  final bool isDoctor;
  final String id;
  final DateTime dateTime;

  const DoneConfirmWidget({Key? key, required this.isDoctor, required this.dateTime, required this.id}) : super(key: key);


  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro> (
      builder: (ctx, val, child) => WillPopScope(
        onWillPop: () async{
          isDoctor? val.archiveDDate(id, dateTime) : val.archiveMDate(id, dateTime);
          val.setNewMessage('');
          return true;
        },
        child: Dialog(
          child: Padding(
            padding: EdgeInsets.all(size.height * 0.02),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Alert For Date', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: size.height * 0.02,),


                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                        child: SizedBox(
                            height: size.height * 0.07,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 0,
                                backgroundColor: Theme.of(context).focusColor,
                                foregroundColor: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                isDoctor? val.archiveDDate(id, dateTime):
                                val.archiveMDate(id, dateTime);
                                val.setNewMessage('');
                              },
                              child: const Text('Archive'),
                            )
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                        child: SizedBox(
                          height: size.height * 0.07,
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                              val.setNewMessage('');
                              isDoctor? val.doneDDate(id):
                              val.doneMDate(id);
                            },
                            child: const Text('Done'),
                          ),
                        ),
                      ),
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
}
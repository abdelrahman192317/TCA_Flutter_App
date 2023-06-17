import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app2m/provider/my_provider.dart';



class AlertConfirmWidget extends StatelessWidget {

  final String title;
  final VoidCallback onPress;

  const AlertConfirmWidget({Key? key, required this.title, required this.onPress}) : super(key: key);


  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro> (
      builder: (ctx, val, child) => Dialog(
        child: Padding(
          padding: EdgeInsets.all(size.height * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Confirm $title', style: Theme.of(context).textTheme.titleLarge),
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
                              val.reset();
                              Navigator.pop(context);
                            },
                            child: const Text('cancel'),
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
                          onPressed: onPress,
                          child: const Text('Confirm'),
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
    );
  }
}
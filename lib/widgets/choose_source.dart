import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import 'package:app2m/provider/my_provider.dart';


class ChooseSourceWidget extends StatelessWidget {


  const ChooseSourceWidget({Key? key}) : super(key: key);


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
              Text('Choose Source', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: size.height * 0.03,),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        val.getImage(ImageSource.camera);
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: size.height * 0.07,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          color: Theme.of(context).focusColor,
                        ),

                        child: Icon(Icons.camera, color: Theme.of(context).primaryColor,),
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        val.getImage(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: size.height * 0.07,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          color: Theme.of(context).focusColor,
                        ),

                        child: Icon(Icons.folder, color: Theme.of(context).primaryColor,),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.02),


              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      val.reset();
                      Navigator.pop(context);
                    },
                    child: const Text('cancel'),
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